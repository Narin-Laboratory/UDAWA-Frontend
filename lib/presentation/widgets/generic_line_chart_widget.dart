import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class GenericLineChart extends StatelessWidget {
  final List<List<FlSpot>> data;
  final String title;
  final String yAxisLabel;
  final double minY;
  final double maxY;

  const GenericLineChart({
    Key? key,
    required this.data,
    required this.title,
    required this.yAxisLabel,
    this.minY = 0,
    this.maxY = 100,
  }) : super(key: key);

  List<LineChartBarData> generateLineChartBars(List<List<FlSpot>> dataList) {
    List<LineChartBarData> lineBars = [];

    int counter = 0;
    Color color = Colors.white;
    for (List<FlSpot> data in dataList) {
      if (counter == 0) {
        color = Colors.blue;
      } else if (counter == 1) {
        color = const Color.fromARGB(50, 96, 125, 139);
      }
      lineBars.add(
        LineChartBarData(
          spots: data,
          color: color,
          // Other common customization...
        ),
      );

      counter++;
    }

    return lineBars;
  }

  @override
  Widget build(BuildContext context) {
    final lineBarsData = generateLineChartBars(data);
    //print(data);
    return Card(
      // Wrap the container in a Card
      margin: const EdgeInsets.all(6.0), // Add optional margin
      child: Container(
        // Use a container for potential padding
        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 32.0),
        height: 400, // Adjust height as needed
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            lineBarsData: lineBarsData,
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                axisNameSize: 32,
                axisNameWidget: Text(yAxisLabel),
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40, // Adjust if needed
                  getTitlesWidget: (value, meta) {
                    final DateTime timestamp =
                        DateTime.fromMillisecondsSinceEpoch(
                            value.toInt() * 1000);
                    // Customize format:
                    if (timestamp.second % 10 == 0) {
                      return Text(DateFormat('mm:ss').format(timestamp));
                    }

                    return const Text("");
                    // Example: Hour:Minutes
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40, // Adjust for label length
                  getTitlesWidget: (value, meta) => Text(
                    value.toString(),
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
