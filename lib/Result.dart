// import 'package:flutter/material.dart';
// import 'Person.dart';

// class ResultScreen extends StatelessWidget {
//   Map<String, Person> result;

//   ResultScreen({super.key});

//   //helper function to sort the transactions by balance
//   List<Person> helperSort(List<Person> arr) {
//     arr.sort(
//       (a, b) {
//         return a.balance.compareTo(b.balance);
//       },
//     );
//     return arr;
//   }

//   List<String> generateResult(List<Person> arr) {
//     int n = arr.length;
//     // ignore: non_constant_identifier_names
//     List<String> results_list = [];
//     while (n > 0) {
//       n = arr.length;
//       arr = helperSort(arr);
//       //if 1 and n-1 same
//       if ((arr[0].balance + arr[n - 1].balance) == 0) {
//         results_list.add(
//             '${arr[0].name} pays ${arr[n - 1].name} Rs ${arr[n - 1].balance}');
//         arr.removeAt(0);
//         n = arr.length;
//         arr.removeAt(n - 1);
//         n = arr.length;
//       } else if ((arr[0].balance + arr[n - 1].balance) > 0) {
//         results_list.add(
//             '${arr[0].name} pays ${arr[n - 1].name} Rs ${(arr[0].balance.abs())}');
//         arr[n - 1].balance = arr[n - 1].balance + arr[0].balance;
//         arr.removeAt(0);
//         n = arr.length;
//       } else {
//         results_list.add(
//             '${arr[0].name} pays ${arr[n - 1].name} Rs ${(arr[n - 1].balance)}');
//         arr[0].balance = arr[n - 1].balance + arr[0].balance;
//         arr.removeAt(n - 1);
//         n = arr.length;
//       }
//     }
//     return results_list;
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Person> person_names = [];
//     List<String> results;
//     List<double> temp_balance = [];

//     result.forEach((key, value) {
//       person_names.add(value);
//       temp_balance.add(value.balance);
//     });
//     print(person_names.length);

//     String temp = "";
//     for (Person p in person_names) {
//       temp += ("${p.name}  ${p.balance}    ");
//     }

//     results = generateResult(person_names);

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Result'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: results.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                     padding: const EdgeInsets.all(10),
//                     child: Text(results[index]));
//               },
//             ),
//           ),
//           const Spacer(),
//           ElevatedButton(
//             style: ButtonStyle(
//                 padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
//                 backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
//             onPressed: () {
//               result.forEach((key, value) {
//                 value.balance = temp_balance.removeAt(0);
//               });
//               Navigator.of(context).pop();
//             },
//             child: const Text(
//               'Back',
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
