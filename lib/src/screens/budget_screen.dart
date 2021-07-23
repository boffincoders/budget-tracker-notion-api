import 'dart:convert';
import 'package:budget_tracker_notion/src/blocs/budget_provider.dart';
import 'package:budget_tracker_notion/src/errors/failure.dart';
import 'package:budget_tracker_notion/src/models/item_model.dart';
import 'package:budget_tracker_notion/src/widgets/refresh.dart';
import 'package:budget_tracker_notion/src/widgets/spending_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'create_page.dart';

class BudgetScreen extends StatefulWidget {
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  SlidableController? slidableController;

  @override
  void initState() {
    // TODO: implement initState
    slidableController = SlidableController();
    super.initState();
  }

  @override
  Widget build(context) {
    final bloc = BudgetProvider.of(context);
    bloc.fetchItems();
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracker'),
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePage()),
              );
            },
            child: Container(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(Icons.add_circle_outline)),
          )
        ],
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(BudgetBloc bloc) {
    return StreamBuilder(
        stream: bloc.items,
        builder: (context, AsyncSnapshot<List<ItemModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final failure = snapshot.error as Failure;
            return Center(
              child: Text(failure.message),
            );
          } else {
            List<ItemModel> items = snapshot.data!;
            return Refresh(
              child: ListView.builder(
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SpendingChart(items: items);
                  }

                  final item = items[index - 1];
                  return Slidable(
                    controller: slidableController,
                    key: Key(item.pageId),
                    actionPane: _getActionPane(index),
                    actionExtentRatio: 0.25,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 2.0,
                          color: getCategoryColor(item.category),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(
                            '${item.category} - ${DateFormat.yMd().format(item.date)}'),
                        trailing: Text(
                          '-\$${item.price.toStringAsFixed(2)}',
                        ),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      /* IconSlideAction(
                        caption: 'Edit',
                        color: Colors.black45,
                        icon: Icons.edit,
                        onTap: () {},
                      ),*/
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red[400],
                        icon: Icons.delete,
                        onTap: () async {
                          var response = await bloc.deletePage(item.pageId);
                          final int statusCode = response.statusCode;
                          if (statusCode == 200) {
                            bloc.fetchItems();
                          } else {
                            final data = jsonDecode(response.body);
                            throw Failure(message: data['message']);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            );
          }
        });
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case 'Entertainment':
      return Colors.red[400]!;
    case 'Food':
      return Colors.green[400]!;
    case 'Personal':
      return Colors.blue[400]!;
    case 'Transportation':
      return Colors.purple[400]!;
    default:
      return Colors.orange[400]!;
  }
}

Widget _getActionPane(int index) {
  switch (index % 4) {
    case 0:
      return SlidableBehindActionPane();
    case 1:
      return SlidableStrechActionPane();
    case 2:
      return SlidableScrollActionPane();
    case 3:
      return SlidableDrawerActionPane();
    default:
      return SlidableBehindActionPane();
  }
}
