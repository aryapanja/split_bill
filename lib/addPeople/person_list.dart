import 'package:flutter/material.dart';
import '../Person.dart';

class PersonList extends StatelessWidget {
  final List<Person> persons;
  final void Function(Person p) onRemovePerson;

  const PersonList(
      {required this.persons, required this.onRemovePerson, super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: persons.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(persons[index]),
        onDismissed: (direction) {
          onRemovePerson(persons[index]);
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(128, 60, 190, 251),
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(2),
          child: Center(
            child: Text(
              persons[index].name,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, letterSpacing: 3, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
