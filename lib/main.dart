import 'package:budget_tracker_notion/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main() async {
  await dotenv.load(fileName: '.env');
  runApp(App());
}
