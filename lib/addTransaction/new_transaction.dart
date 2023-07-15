import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:selectable_list/selectable_list.dart';
import '../transaction.dart';

class NewTransaction extends StatefulWidget {
  final List<Map<String, dynamic>> totalPeople;
  final void Function(Transactions t) onAddTransaction;

  const NewTransaction({
    required this.totalPeople,
    required this.onAddTransaction,
    Key? key,
  }) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  List<String> temp = [];
  List<String> tempSelect = [];
  String? payee;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void submitTransactionData() {
    final amt = double.tryParse(_amountController.text);

    final isValidAmt = amt == null || amt <= 0;
    if (isValidAmt || tempSelect.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text(
                'Please make sure all the correct values have been entered'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
      return;
    }

    List<Map<String, dynamic>> getPeople(List<String> arr) {
      List<Map<String, dynamic>> selectedPeople = [];
      for (Map<String, dynamic> p in widget.totalPeople) {
        if (arr.contains(p['name'])) {
          selectedPeople.add(p);
        }
      }
      return selectedPeople;
    }

    widget.onAddTransaction(
      Transactions(
        name: payee!,
        pay: amt,
        selected: getPeople(tempSelect),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> totalPeople = widget.totalPeople;
    temp = totalPeople.map<String>((p) => p['name'] as String).toList();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: [
              DropdownButton(
                hint: Row(
                  children: const [
                    Icon(Icons.person_2), // Add the desired icon
                    SizedBox(width: 12),
                    Text('Select payer'),
                  ],
                ),
                value: payee,
                items: temp
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    payee = value.toString();
                  });
                },
              ),
              const SizedBox(width: 60),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    prefixText: 'Rs',
                    labelText: "Amount",
                  ),
                ),
              ),
            ],
          ),
          MultiSelectDialogField(
            items: temp.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            onConfirm: (values) {
              setState(() {
                tempSelect = values;
              });
            },
            buttonText: tempSelect.isEmpty
                ? const Text("Select your friends for split up")
                : const Text("Selected people"),
          ),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    tempSelect.clear();
                  });
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: submitTransactionData,
                child: const Text('Save Transaction'),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
