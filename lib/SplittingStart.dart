import 'package:flutter/material.dart';
import 'package:split_bill/home_page.dart';
import 'package:split_bill/sql_helper.dart';
import 'package:split_bill/transaction.dart';
import 'Result.dart';
import 'addTransaction/new_transaction.dart';

class SplittingStart extends StatefulWidget {
  List<Map<String, dynamic>> groupedPeople = [];

  SplittingStart({required this.groupedPeople, super.key});
  @override
  State<SplittingStart> createState() {
    return _SplittingStartState();
  }
}

class _SplittingStartState extends State<SplittingStart> {
  List<Map<String, dynamic>> transactionlist = [];
  Map<String, dynamic>? payer;

  @override
  initState() {
    super.initState();
    refreshTransactions();
    setState(() {
      refreshPersons();
    });
  }

  void refreshTransactions() async {
    final data = await SQLHelper.getTransactions();
    setState(() {
      transactionlist = data;
    });
  }

  void refreshPersons() async {
    final data = await SQLHelper.getItems();
    setState(() {
      widget.groupedPeople = data;
    });
  }

  void _openNewTransactionOverlay() {
    List<Map<String, dynamic>> arr = widget.groupedPeople;
    showModalBottomSheet(
      //isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewTransaction(
          totalPeople: arr,
          onAddTransaction: _addTransaction,
        );
      },
    );
  }

  void _updateItem(String name, double balance) async {
    await SQLHelper.updateItem(name, balance);
    refreshPersons();
  }

  String convertSelectedPeople(List<Map<String, dynamic>> selectedPeople) {
    String s = "";

    for (Map<String, dynamic> p in selectedPeople) {
      s += (p['name'] + ", ");
    }
    return s;
  }

  void _addTransaction(Transactions t) async {
    List<Map<String, dynamic>> groupedPeople = widget.groupedPeople;

    //n stores the number of people present
    int n = t.selected.length;
    //each stores amount each has to pay
    double each = (t.pay / n);

    //List<Map<String, dynamic>> groupedPeople = widget.groupedPeople;
    List<Map<String, dynamic>> selectedPersons = t.selected;

    for (Map<String, dynamic> p in selectedPersons) {
      double temp = p['balance'];
      temp = temp - each;
      _updateItem(p['name'], temp);
    }

    final data = await SQLHelper.getItems();
    setState(() {
      groupedPeople = data;
    });

    for (Map<String, dynamic> p in groupedPeople) {
      if (p['name'] == t.name) {
        //print(t.name);
        //print(p['balance']);
        double temp = p['balance'];
        temp = temp + t.pay;
        _updateItem(p['name'], temp);
      }
    }
    String temp = t.category.toString().replaceAll('Categories.', '');
    await SQLHelper.createTransaction(
        t.name, t.pay, convertSelectedPeople(t.selected), temp);

    setState(() {
      refreshTransactions();
      refreshPersons();
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return const HomePage();
    }), (r) {
      return false;
    });
    return false;
  }

  String returnAsset(String t) {
    if (t == "entertainment") {
      return "assets/entertainment.png";
    } else if (t == "accomodation") {
      return "assets/accomodation.png";
    } else if (t == "travel") {
      return "assets/travel.jpg";
    } else if (t == "food") {
      return "assets/food.png";
    }
    return "assets/miscellaneous.png";
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text(
        "No transactions, start by adding some",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );

    if (transactionlist.isNotEmpty) {
      mainContent = ListView.builder(
          itemCount: transactionlist.length,
          itemBuilder: (context, index) => Card(
            elevation: 10,
                margin: const EdgeInsets.fromLTRB(15, 2, 15, 0),
                color: const Color.fromARGB(236, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // border: Border.all(
                          //     color: const Color.fromARGB(255, 0, 0, 0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes the position of the shadow
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage(
                              returnAsset(transactionlist[index]['category']),
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${transactionlist[index]['name']} paid for',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Text('${transactionlist[index]['selected']}',
                                style: const TextStyle(fontSize: 10)),
                            const Divider(
                              color: Color.fromARGB(145, 0, 0, 0),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 2),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 248, 248, 229),
                                borderRadius: BorderRadius.circular(5),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey.withOpacity(0.5),
                                //     spreadRadius: 1,
                                //     blurRadius: 12,
                                //     offset: const Offset(0,
                                //         3), // changes the position of the shadow
                                //   ),
                                // ],
                              ),
                              child: Text(transactionlist[index]['category']),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          //color: Colors.amber.shade400,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(0),
                          ),
                        ),
                        child: Text(
                          'Rs ${transactionlist[index]['pay']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/transaction_screen.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          extendBody: true,
          backgroundColor: const Color.fromARGB(0, 0, 238, 255),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 90,
                ),
                Visibility(
                  visible: transactionlist.isNotEmpty ? true : false,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                    child: Text(
                      'Transactions',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: mainContent,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: SizedBox(
            width: 70,
            height: 70,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: _openNewTransactionOverlay,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  iconSize: 40,
                  onPressed: _onWillPop,
                  icon: const Icon(Icons.home,
                      color: Color.fromARGB(255, 69, 183, 73)),
                ),
                IconButton(
                  iconSize: 40,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ResultScreen(result: widget.groupedPeople),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calculate,
                      color: Color.fromARGB(255, 228, 67, 56)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
