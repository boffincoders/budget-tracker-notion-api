import 'package:budget_tracker_notion/src/screens/budget_screen.dart';
import 'package:flutter/material.dart';
import 'blocs/budget_provider.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return BudgetProvider(
      key: Key('budgetList'),
      child: MaterialApp(
        title: 'Budget App',
        theme: ThemeData(primaryColor: Colors.white),
        debugShowCheckedModeBanner: false,
        home: BudgetScreen(),
      ),
    );
  }
}
