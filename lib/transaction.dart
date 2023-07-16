import 'package:flutter/material.dart';

enum Categories { accomodation, travel, food, entertainment, miscellaneous }

const categoryIcons = {
  Categories.accomodation: Icons.hotel,
  Categories.travel: Icons.travel_explore,
  Categories.food: Icons.lunch_dining,
  Categories.entertainment: Icons.movie,
  Categories.miscellaneous: Icons.miscellaneous_services,
  // Categories.food: Icons.lunch_dining,
  // Categories.travel: Icons.flight_takeoff,
  // Categories.leisure: Icons.movie,
  // Categories.work: Icons.work,
};



class Transactions {
  final String name;
  final double pay;
  List<Map<String, dynamic>> selected;
  final Categories category;

  Transactions(
      {required this.name,
      required this.pay,
      required this.selected,
      required this.category});
}
