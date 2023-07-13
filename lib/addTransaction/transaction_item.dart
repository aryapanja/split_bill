// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import '../transaction.dart';
// //import 'package:split_bill/addTransaction/transaction.dart';

// class TransactionItem extends StatelessWidget {
//   final Transactions t;
//   const TransactionItem(this.t, {super.key});

//   @override
//   Widget build(context) {
//     String eachPay = (t.pay / t.selected.length).toStringAsFixed(2);
//     final List<String> tArr = t.selected.map((e) => e.name).toList();

//     //Card does not have padding parameter
//     return Card(
//       color: Colors.blue.shade50,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 8,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '${t.name} paid Rs ${t.pay}',
//               style: const TextStyle(fontSize: 15),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5),
//               child: Container(
//                 height: 2.0,
//                 width: double.infinity,
//                 color: const Color.fromARGB(101, 0, 52, 197),
//               ),
//             ),
//             Text(
//               'Split among:  ${tArr.join(', ')}',
//               style: const TextStyle(fontSize: 10),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
