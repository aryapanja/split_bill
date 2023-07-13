import 'package:flutter/material.dart';
import 'package:split_bill/person.dart';
import 'package:split_bill/home_page.dart';
//import 'addTransaction/new_transaction.dart';

class Transaction extends StatefulWidget {
  List<Person> arr;
  Transaction({required this.arr, super.key});

  @override
  State<Transaction> createState() {
    return _TransactionState();
  }
}

class _TransactionState extends State<Transaction> {
  @override
  Widget build(Object context) {
    // ignore: unused_local_variable
    List<Person> group = widget.arr;
    //List<Transaction> transactions = [];

    return Scaffold(
      body: Column(
        children: [
          AppBar(
            //if there is a previous page, appbar by default creates a 'go back' button. We can disable it by setting the the following to false
            automaticallyImplyLeading: false,
            title: const Text("Transactions"),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          /*
          ElevatedButton(
            onPressed: () {
              Navigator.push(this.context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            child: const Text("Go back"),
          ),*/
        ],
      ),
    );
  }
}
