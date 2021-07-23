import 'package:flutter/material.dart';
import './budget_bloc.dart';
export './budget_bloc.dart';

class BudgetProvider extends InheritedWidget {
  final BudgetBloc bloc;

  BudgetProvider({required Key key, required Widget child})
      : bloc = BudgetBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static BudgetBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BudgetProvider>()!.bloc;
  }
}
