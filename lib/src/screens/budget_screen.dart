import 'dart:convert';
import 'package:budget_tracker_notion/src/blocs/budget_provider.dart';
import 'package:budget_tracker_notion/src/errors/failure.dart';
import 'package:budget_tracker_notion/src/models/item_model.dart';
import 'package:budget_tracker_notion/src/widgets/refresh.dart';
import 'package:budget_tracker_notion/src/widgets/spending_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

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
            List<Element> _elements = [];
            items.forEach((element) {
              _elements.add(Element(element.date, element));
            });

            return Container(
              child: Column(
                children: [
                  SpendingChart(items: items),
                  Expanded(
                    child: Refresh(
                      child: StickyGroupedListView<Element, DateTime>(
                        elements: _elements,
                        order: StickyGroupedListOrder.DESC,
                        groupBy: (Element element) => DateTime(
                          element.date.year,
                          element.date.month,
                        ),
                        groupSeparatorBuilder: (Element element) => Container(
                            width: MediaQuery.of(context).size.width,
                            color: Color(0x45C4C4C4),
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                              child: Text(
                                '${getMonth(element.date.month)} ${element.date.year}',
                                style: TextStyle(
                                    fontSize: 12.0, color: Color(0xff000000)),
                              ),
                            )),
                        floatingHeader: false,
                        itemBuilder: (_, Element element) {
                          return Slidable(
                            controller: slidableController,
                            key: Key(element.itemData.pageId),
                            actionPane: SlidableStrechActionPane(),
                            actionExtentRatio: 0.25,
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  width: 2.0,
                                  color: getCategoryColor(
                                      element.itemData.category),
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
                                title: Text(element.itemData.name),
                                subtitle: Text(
                                    '${element.itemData.category} - ${DateFormat.yMd().format(element.date)}'),
                                trailing: Text(
                                  '-\$${element.itemData.price.toStringAsFixed(2)}',
                                ),
                              ),
                            ),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Edit',
                                color: Colors.lightGreen[300],
                                icon: Icons.edit,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreatePage(
                                              itemData: element.itemData,
                                              isEdit: true,
                                            )),
                                  );
                                },
                              ),
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red[400],
                                icon: Icons.delete,
                                onTap: () async {
                                  var response = await bloc
                                      .deletePage(element.itemData.pageId);
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
                    ),
                  ),
                ],
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

class Element implements Comparable {
  DateTime date;
  ItemModel itemData;

  Element(this.date, this.itemData);

  @override
  int compareTo(other) {
    return date.compareTo(other.date);
  }
}

String getMonth(int index) {
  const monthNames = [
    "JANUARY",
    "FEBRUARY",
    "MARCH",
    "APRIL",
    "MAY",
    "JUNE",
    "JULY",
    "AUGUST",
    "SEPTEMBER",
    "OCTOBER",
    "NOVEMBER",
    "DECEMBER"
  ];
  return monthNames[index - 1];
}
