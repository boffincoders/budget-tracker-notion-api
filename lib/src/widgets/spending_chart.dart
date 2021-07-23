import 'package:budget_tracker_notion/src/models/item_model.dart';
import 'package:budget_tracker_notion/src/screens/budget_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpendingChart extends StatelessWidget {
  final List<ItemModel> items;

  const SpendingChart({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spending = <String, double>{};
    items.forEach((item) => spending.update(
        item.category, (value) => value + item.price,
        ifAbsent: () => item.price));
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 360.0,
        child: Column(
          children: [
            Expanded(child: buildPiieChart(spending)),
            const SizedBox(
              height: 20.0,
            ),
            Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: spending.keys
                    .map((category) => Indicator(
                          color: getCategoryColor(category),
                          text: category,
                        ))
                    .toList()),
          ],
        ),
      ),
    );
  }

  Widget buildPiieChart(Map<String, double> spending) {
    return PieChart(
      PieChartData(
        sections: spending
            .map((cat, ttl) => MapEntry(
                cat,
                PieChartSectionData(
                    color: getCategoryColor(cat),
                    radius: 100.0,
                    title: '\$${ttl.toStringAsFixed(2)}',
                    value: ttl)))
            .values
            .toList(),
        sectionsSpace: 0.5,
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 16.0,
          width: 16.0,
          color: color,
        ),
        const SizedBox(
          height: 4.0,
        ),
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
