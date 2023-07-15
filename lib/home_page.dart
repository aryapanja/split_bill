import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
  late Widget mainContent;

  @override
  void initState() {
    super.initState();
    setState(() {
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

  //functin to add a 'Person' member to the database
  void _addPerson(Person p) async {
    await SQLHelper.createItem(p.name, p.balance);
    refreshPersons();
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
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        title: const Center(
          child: Text('SPLIT YOUR BILL'),
        ),
        actions: [
          IconButton(
            onPressed: _openAddPersonOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
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
                      builder: (context) => SplittingStart(
                          groupedPeople: splitPeople,
                          onCreateNewGroup: clearDatabase),
                    ),
                  );
                },
                child: const Text("Create Group"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
