import 'package:flutter/material.dart';
import 'package:udawa/presentation/widgets/key_value_widget.dart';

class WaterTemperatureWidget extends StatefulWidget {
  final double celsius;
  final double min;
  final double max;
  final double average;

  const WaterTemperatureWidget(
      {Key? key,
      required this.celsius,
      required this.min,
      required this.max,
      required this.average})
      : super(key: key);

  @override
  _WaterTemperatureWidgetState createState() => _WaterTemperatureWidgetState();
}

class _WaterTemperatureWidgetState extends State<WaterTemperatureWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic iconColor = Colors.blue;

    if (widget.celsius < 10) {
      iconColor = Colors.deepPurple;
    } else if (widget.celsius >= 10 && widget.celsius <= 17) {
      iconColor = Colors.deepPurpleAccent;
    } else if (widget.celsius > 17 && widget.celsius <= 23) {
      iconColor = Colors.blue;
    } else if (widget.celsius > 23 && widget.celsius <= 29) {
      iconColor = Colors.red;
    } else if (widget.celsius > 29 && widget.celsius <= 35) {
      iconColor = Colors.orange;
    } else if (widget.celsius > 35) {
      iconColor = Colors.yellow;
    }
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0), // Example padding
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Water Temperature", // Display current slider value
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w100,
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.thermostat,
                        color: iconColor,
                        size: 40,
                      ), // Customize icon & color
                    ),
                    TextSpan(
                      text: " ${widget.celsius.toStringAsFixed(2)}°C",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: iconColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 30),
              KeyValueWidget(
                  label: 'Min', value: "${widget.min.toStringAsFixed(2)}°C"),
              KeyValueWidget(
                  label: 'Max', value: "${widget.max.toStringAsFixed(2)}°C"),
              KeyValueWidget(
                  label: 'Average',
                  value: "${widget.average.toStringAsFixed(2)}°C"),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
