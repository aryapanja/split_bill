import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect/multiselect.dart';
import 'package:split_bill/Person.dart';
//import 'package:split_bill/addTransaction/transaction.dart';

import '../transaction.dart';

class NewTransaction extends StatefulWidget {
  //variable declaration
  List<Map<String, dynamic>> totalPeople = [];
  late void Function(Transactions t) onAddTransaction;

  // NewTransaction({super.key});

  NewTransaction(
      {required this.totalPeople, required this.onAddTransaction, super.key});
  @override
  State<NewTransaction> createState() {
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  List<Map<String, dynamic>> selectedPeople = [];
  String select = "";
  //String selectedName = "Puneet";

  void submitTransactionData() {
    final amt = double.tryParse(_amountController.text);

    final isValidAmt = amt == null || amt <= 0;
    if (_nameController.text.trim().isEmpty ||
        isValidAmt ||
        selectedPeople.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text(
                'Please make sure all the correct values have been entered'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              )
            ],
          );
        },
      );
      return;
    }

    widget.onAddTransaction(
      Transactions(
        name: _nameController.text,
        pay: amt,
        selected: selectedPeople,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //fetching Person list from NewTransaction class
    List<Map<String, dynamic>> totalPeople = widget.totalPeople;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: [
              // DropdownButton(
              //   value: arr[0],
              //   hint: const Text("Choose payee"),
              //   items: arr
              //       .map(
              //         (e) => DropdownMenuItem(child: Text(e)),
              //       )
              //       .toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       selectedName = value;
              //     });
              //   },
              // ),
              Expanded(
                child: TextField(
                  controller: _nameController,
                  maxLength: 20,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text('Payee'),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    prefixText: 'Rs',
                    label: Text("Amount"),
                  ),
                ),
              )
            ],
          ),
          /* //not working
          DropDownMultiSelect(
            options: const ['a', 'b', 'c', 'd'],
            selectedValues: selectedPeople,
            onChanged: (x) {
              setState(() {
                selectedPeople = x;
              });
            },
            whenEmpty: 'Select people to split bill',
          )*/
          MultiSelectDialogField(
            items:
                totalPeople.map((e) => MultiSelectItem(e, e['name'])).toList(),
            onConfirm: (values) {
              setState(() {
                selectedPeople = values;
                print(selectedPeople.length);
              });
            },
            buttonText: const Text("Select person"),
          ),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {
                  selectedPeople.clear();
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: submitTransactionData,
                child: const Text('Save Transaction'),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
