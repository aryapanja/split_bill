import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:split_bill/pie_chart/pie_view.dart';
import 'package:split_bill/sql_helper.dart';
import 'Person.dart';
import 'SplittingStart.dart';
import 'addPeople/new_person.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  //variable declarations
  List<Map<String, dynamic>> splitPeople = [];
  List<Map<String, dynamic>> transactionlist = [];
  late Widget mainContent;

  @override
  void initState() {
    super.initState();
    setState(() {
      refreshTransactions();
      refreshPersons();
    });
  }

  //set the splitPeople list with 'Person' data from database
  void refreshPersons() async {
    final data = await SQLHelper.getItems();
    setState(() {
      splitPeople = data;
    });
  }

  void clearDatabase() {
    SQLHelper.removeAllRowsFromTable();
    refreshPersons();
  }

  //functin to add a 'Person' member to the database
  void _addPerson(Person p) async {
    await SQLHelper.createItem(p.name, p.balance);
    refreshPersons();
  }

  void refreshTransactions() async {
    final data = await SQLHelper.getTransactions();
    setState(() {
      transactionlist = data;
    });
  }

  //function to open the modal sheet to add new member to the group
  void _openAddPersonOverlay() {
    showModalBottomSheet(
      isScrollControlled:
          true, //this ensures that the modal takes the entire height of the page
      context: context,
      builder: (ctx) {
        //return a widget
        return NewPerson(onAddPerson: _addPerson);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //if no person in the group we print a text otherwise we show the persons present in the group
    if (splitPeople.isEmpty) {
      mainContent = const Center(
        child: Text('No person found, start by adding people!'),
      );
    } else if (splitPeople.isNotEmpty) {
      mainContent = ListView.builder(
        itemCount: splitPeople.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blue.shade400,
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text(splitPeople[index]['name']),
            subtitle: Text(splitPeople[index]['balance'].toString()),
          ),
        ),
      );
    }

    //returning widget
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/homepage.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 130,
              ),
              Expanded(
                child: mainContent,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Visibility(
                  visible: splitPeople.length >= 2,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SplittingStart(groupedPeople: splitPeople),
                        ),
                      );
                    },
                    child: const Text("Create Group"),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  refreshTransactions();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PieView(
                            transactions: transactionlist,
                          )));
                },
                child: const Text('Show Pie'),
              ),
              TextButton(
                  onPressed: () {
                    clearDatabase();
                  },
                  child: const Text('Delete Group'),
                ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: _openAddPersonOverlay,
              tooltip: 'Add Transaction',
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: const Color.fromARGB(121, 255, 255, 255),
          shape: const CircularNotchedRectangle(),
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                iconSize: 40,
                onPressed: () {},
                icon: const Icon(Icons.home,
                    color: Color.fromARGB(255, 69, 183, 73)),
              ),
              IconButton(
                  iconSize: 40,
                  onPressed: () {},
                  icon: const Icon(Icons.calculate,
                      color: Color.fromARGB(255, 228, 67, 56)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
