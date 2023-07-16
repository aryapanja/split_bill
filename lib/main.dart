import 'package:flutter/material.dart';
import 'package:split_bill/sql_helper.dart';
import 'home_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future main() async {
  
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
  runApp(
    const MaterialApp(
      home: HomePage(),
    ),
  );
}
