import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class GenericLineChart extends StatelessWidget {
  final List<FlSpot> data;
  final String title;
  final String yAxisLabel;

  const GenericLineChart({
    Key? key,
    required this.data,
    required this.title,
    required this.yAxisLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print(data);
    return Card(
      // Wrap the container in a Card
      margin: const EdgeInsets.all(6.0), // Add optional margin
      child: Container(
        // Use a container for potential padding
        padding: const EdgeInsets.all(12.0), // Add optional padding
        height: 400, // Adjust height as needed
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: data,
                // ... Other common customization ...
              )
            ],
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 40, // Adjust if needed
                  getTitlesWidget: (value, meta) {
                    final DateTime timestamp =
                        DateTime.fromMillisecondsSinceEpoch(
                            value.toInt() * 1000);
                    // Customize format:
                    return Text(DateFormat('hh:mm')
                        .format(timestamp)); // Example: Hour:Minutes
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 40, // Adjust for label length
                  getTitlesWidget: (value, meta) => Text(
                    yAxisLabel,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) => Text(title),
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
