import 'package:flutter/material.dart';
import '../Person.dart';

class NewPerson extends StatefulWidget {
  final void Function(Person p) onAddPerson;

  const NewPerson({required this.onAddPerson, super.key});

  @override
  State<NewPerson> createState() {
    return _NewPersonState();
  }
}

class _NewPersonState extends State<NewPerson> {
  final _nameController = TextEditingController();

  void submit() {
    if (_nameController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text('Please make sure name has been entered'),
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
    widget.onAddPerson(
      Person(
        name: _nameController.text.trim(),
        balance: 0.0,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            maxLength: 20,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              label: Text('Name'),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                onPressed: submit,
                child: const Text('Add Person'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
