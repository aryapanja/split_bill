import 'package:flutter/material.dart';
import 'package:split_bill/home_page.dart';
import 'package:split_bill/sql_helper.dart';
import 'package:split_bill/transaction.dart';
import 'Result.dart';
import 'addTransaction/new_transaction.dart';

class SplittingStart extends StatefulWidget {
  List<Map<String, dynamic>> groupedPeople = [];
  void Function() onCreateNewGroup;

  SplittingStart(
      {required this.groupedPeople, required this.onCreateNewGroup, super.key});
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
      createSummary();
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

  List<String> createSummary() {
    List<String> summary = [];
    for (Map<String, dynamic> p in widget.groupedPeople) {
      if (p['balance'] > 0) {
        String name = p['name'];
        summary.add('$name paid Rs ${p['balance']} extra.');
      } else if (p['balance'] < 0) {
        String name = p['name'];
        summary.add('$name owes Rs ${p['balance'].abs()}');
      }
    }
    return summary;
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

    await SQLHelper.createTransaction(t.name, t.pay,
        convertSelectedPeople(t.selected), t.category.toString());

    setState(() {
      refreshTransactions();
      refreshPersons();
      createSummary();
    });
  }

  Future<bool> _onWillPop() async {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
    //     (Route<dynamic> route) => route is HomePage);
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return const HomePage();
    }), (r) {
      return false;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List<String> summary = createSummary();
    Widget mainContent = const Center(
      child: Text("No transactions, start by adding some"),
    );

    if (transactionlist.isNotEmpty) {
      mainContent = ListView.builder(
        itemCount: transactionlist.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blue.shade400,
          margin: const EdgeInsets.all(3),
          child: ListTile(
            title: Text(transactionlist[index]['name']),
            subtitle: Column(children: [
              Text(transactionlist[index]['pay'].toString()),
              const SizedBox(
                height: 2,
              ),
              Text(transactionlist[index]['selected']),
              const SizedBox(
                height: 2,
              ),
              Text(transactionlist[index]['category']),
            ]),
          ),
        ),
      );
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          //if there is a previous page, appbar by default creates a 'go back' button. We can disable it by setting the the following to false
          automaticallyImplyLeading: false,
          title: const Text("Transactions"),
          actions: [
            IconButton(
              onPressed: _openNewTransactionOverlay,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: mainContent,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(118, 87, 132, 208), width: 2),
              ),
              child: summary.isEmpty
                  ? const Text('Nothing to settle')
                  : ListView.builder(
                      itemCount: summary.length,
                      itemBuilder: (context, index) => Text(summary[index]),
                    ),
            ),
            //buttons in the floor
            Row(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(0.1),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text('**Attention**'),
                            content: const Text(
                                'This will delete your group and all transaction details'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget.onCreateNewGroup();
                                  Navigator.of(ctx).pop();
                                  Navigator.pop(context);
                                },
                                child: const Text('Confirm'),
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: const Text("Create new group"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ResultScreen(result: widget.groupedPeople),
                        ),
                      );
                    },
                    child: const Text("Settle up"),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            )
          ],
        ),
      ),
    );
  }
}
