import 'package:flutter/material.dart';
import 'Person.dart';

class ResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> result;

  ResultScreen({required this.result, Key? key}) : super(key: key);

  List<Person> filterAndCreatePersons() {
    List<Person> personNames = result
        .where((p) => p['balance'] != 0.0)
        .map((p) => Person(balance: p['balance'], name: p['name']))
        .toList();
    return personNames;
  }

  List<String> generateResult(List<Person> persons) {
    List<String> results = [];
    persons.sort((a, b) => a.balance.compareTo(b.balance));
    while (persons.length > 1) {
      Person person1 = persons.first;
      Person person2 = persons.last;

      if (person1.balance + person2.balance == 0) {
        results
            .add('${person1.name} pays ${person2.name} Rs ${person2.balance}');
        persons.removeAt(0);
        persons.removeLast();
      } else if (person1.balance + person2.balance > 0) {
        results.add(
            '${person1.name} pays ${person2.name} Rs ${person1.balance.abs()}');
        persons.last.balance += person1.balance;
        persons.removeAt(0);
      } else {
        results
            .add('${person1.name} pays ${person2.name} Rs ${person2.balance}');
        person1.balance += person2.balance;
        persons.removeLast();
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    List<Person> personNames = filterAndCreatePersons();
    List<String> results = generateResult(personNames);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Result'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(results[index]),
                );
              },
            ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
