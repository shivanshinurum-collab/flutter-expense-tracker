import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:expense_app/models/models.dart';

class WeekBarChart extends StatefulWidget {
  final List<Transaction>? _transactions;

  WeekBarChart({List<Transaction>? transactions = const []}) : _transactions = transactions;

  @override
  State<StatefulWidget> createState() => WeekBarChartState();
}

class WeekBarChartState extends State<WeekBarChart> {
  int _touchedIndex = -1;
  double _total = 0.0;
  List<double> _spendings = List.generate(7, (index) => 0);

  double _calculateTotal() {
    if (_spendings.isNotEmpty) {
      _spendings.clear();
      _spendings = List.generate(7, (index) => 0);
    }

    if (widget._transactions == null || widget._transactions!.isEmpty) {
      return 0;
    }
    double sum = 0;
    for (Transaction transaction in widget._transactions!) {
      _spendings[transaction.date.weekday - 1] += transaction.amount;
      sum += transaction.amount;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    _calculateTotal();
    _total = _spendings.reduce(max);
    if (_total == 0) _total = 100; // avoid div by zero

    return Container(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: BarChart(_mainBarData()),
      ),
    );
  }

  BarChartGroupData _makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 22,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isTouched ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withOpacity(0.7),
          width: width,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: _total,
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  // Actual Data
  List<BarChartGroupData> _showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return _makeGroupData(0, _spendings[0],
                isTouched: i == _touchedIndex);
          case 1:
            return _makeGroupData(1, _spendings[1],
                isTouched: i == _touchedIndex);
          case 2:
            return _makeGroupData(2, _spendings[2],
                isTouched: i == _touchedIndex);
          case 3:
            return _makeGroupData(3, _spendings[3],
                isTouched: i == _touchedIndex);
          case 4:
            return _makeGroupData(4, _spendings[4],
                isTouched: i == _touchedIndex);
          case 5:
            return _makeGroupData(5, _spendings[5],
                isTouched: i == _touchedIndex);
          case 6:
            return _makeGroupData(6, _spendings[6],
                isTouched: i == _touchedIndex);
          default:
            return _makeGroupData(6, 0);
        }
      });

  BarChartData _mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: const Color(0xFF4A4642),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay = "";
              switch (group.x.toInt()) {
                case 0: weekDay = 'Mon'; break;
                case 1: weekDay = 'Tue'; break;
                case 2: weekDay = 'Wed'; break;
                case 3: weekDay = 'Thu'; break;
                case 4: weekDay = 'Fri'; break;
                case 5: weekDay = 'Sat'; break;
                case 6: weekDay = 'Sun'; break;
              }
              return BarTooltipItem(
                  '$weekDay\n₹${rod.toY.toStringAsFixed(0)}',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
            }),
        touchCallback: (touchEvent, barTouchResponse) {
          setState(() {
            if (barTouchResponse != null &&
                barTouchResponse.spot != null &&
                touchEvent.isInterestedForInteractions) {
              _touchedIndex = barTouchResponse.spot?.touchedBarGroupIndex ?? -1;
            } else {
              _touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => Text(
              '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            getTitlesWidget: (value, meta) {
              String text = '';
              switch (value.toInt()) {
                case 0:
                  text = 'M';
                  break;
                case 1:
                  text = 'T';
                  break;
                case 2:
                  text = 'W';
                  break;
                case 3:
                  text = 'T';
                  break;
                case 4:
                  text = 'F';
                  break;
                case 5:
                  text = 'S';
                  break;
                case 6:
                  text = 'S';
                  break;
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 16,
                child: Text(
                  text,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: _showingGroups(),
    );
  }
}
