import 'package:split_bill/Person.dart';

class Transactions {
  final String name;
  final double pay;
  List<Map<String, dynamic>> selected;

  Transactions({required this.name, required this.pay, required this.selected});
}
