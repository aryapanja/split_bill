import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieView extends StatefulWidget {
  List<Map<String, dynamic>> transactions;

  PieView({required this.transactions, super.key});
  @override
  State<PieView> createState() {
    return _PieViewState();
  }
}

class _PieViewState extends State<PieView> {
  late double totalExpense = getTotalExpense();
  List<String> category = [
    "Categories.accomodation",
    "Categories.travel",
    "Categories.food",
    "Categories.entertainment",
    "Categories.miscellaneous"
  ];
  final colorData = <Color>[
    Colors.amberAccent,
    Colors.blue,
    Colors.deepOrangeAccent,
    Colors.teal,
    Colors.redAccent,
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> transactions = widget.transactions;
    List<double> percentage = [];
    percentage = forCategory(transactions, category);

    Map<String, double> dataMap = {};
    for (int i = 0; i < percentage.length; i++) {
      dataMap[category[i]] = percentage[i];
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 10),
            child: PieChart(
              
              dataMap: dataMap,
              animationDuration: const Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 2,
              colorList: colorData,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 53,
              centerText: "TOTAL EXPENSES",
              legendOptions: const LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.bottom,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: false,
                showChartValues: true,
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage("assets/entertainment.png"),
                  fit: BoxFit.fill),
            ),
          ),
        ],
      ),
    );
  }

  double getTotalExpense() {
    double total = 0;
    for (Map<String, dynamic> t in widget.transactions) {
      total += t['pay'];
    }
    return total;
  }

  List<double> forCategory(
      List<Map<String, dynamic>> transactions, List<String> category) {
    List<double> arr = [];
    double sum;
    for (int i = 0; i < category.length; i++) {
      sum = 0.0;
      for (int j = 0; j < transactions.length; j++) {
        if (category[i] == transactions[j]['category']) {
          sum += transactions[j]['pay'];
        }
      }
      arr.add(((sum / totalExpense) * 100).roundToDouble());
    }
    return arr;
  }
}
