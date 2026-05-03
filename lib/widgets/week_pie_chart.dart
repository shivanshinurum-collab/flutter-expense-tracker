import 'package:expense_app/models/models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeekPieChart extends StatefulWidget {
  final List<Transaction>? _transactions;
  const WeekPieChart({Key? key, List<Transaction>? transactions})
      : _transactions = transactions,
        super(key: key);

  @override
  _WeekPieChartState createState() => _WeekPieChartState();
}

class _WeekPieChartState extends State<WeekPieChart> {
  List<double> _spendings = List.generate(7, (index) => 0);

  void _generateWeeklyReport() {
    if (_spendings.isNotEmpty) {
      _spendings.clear();
      _spendings = List.generate(7, (index) => 0);
    }
    if (widget._transactions == null) return;
    for (Transaction transaction in widget._transactions!) {
      _spendings[transaction.date.weekday - 1] += transaction.amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    _generateWeeklyReport();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: [
                  _buildPieSection(0, Colors.redAccent, 'Mon'),
                  _buildPieSection(1, Colors.deepPurpleAccent, 'Tue'),
                  _buildPieSection(2, Colors.blueAccent, 'Wed'),
                  _buildPieSection(3, Colors.greenAccent, 'Thu'),
                  _buildPieSection(4, Colors.orangeAccent, 'Fri'),
                  _buildPieSection(5, Colors.cyanAccent, 'Sat'),
                  _buildPieSection(6, Colors.pinkAccent, 'Sun'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildIndicator(Colors.redAccent, 'Mon'),
              _buildIndicator(Colors.deepPurpleAccent, 'Tue'),
              _buildIndicator(Colors.blueAccent, 'Wed'),
              _buildIndicator(Colors.greenAccent, 'Thu'),
              _buildIndicator(Colors.orangeAccent, 'Fri'),
              _buildIndicator(Colors.cyanAccent, 'Sat'),
              _buildIndicator(Colors.pinkAccent, 'Sun'),
            ],
          ),
        ],
      ),
    );
  }

  PieChartSectionData _buildPieSection(int index, Color color, String title) {
    final value = _spendings[index];
    final isSelected = value > 0;
    return PieChartSectionData(
      color: color,
      value: isSelected ? value : 1, // Show tiny slice if zero to keep layout
      title: isSelected ? '₹${value.toStringAsFixed(0)}' : '',
      radius: 60,
      showTitle: isSelected && value > (_spendings.reduce((a, b) => a + b) / 10),
      titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildIndicator(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  final Color _color;
  final String _text;
  final double _size;
  final Color _textColor;

  const Indicator({
    Key? key,
    required Color color,
    required String text,
    double size = 16,
    Color textColor = const Color(0xff505050),
  })  : _color = color,
        _text = text,
        _size = size,
        _textColor = textColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          _text,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: _textColor),
        )
      ],
    );
  }
}


