import 'package:flutter/material.dart';
import 'package:udawa/presentation/widgets/key_value_widget.dart';

class PowerWattageWidget extends StatefulWidget {
  final double watt;
  final double min;
  final double max;
  final double average;

  const PowerWattageWidget(
      {Key? key,
      required this.watt,
      required this.min,
      required this.max,
      required this.average})
      : super(key: key);

  @override
  _PowerWattageWidgetState createState() => _PowerWattageWidgetState();
}

class _PowerWattageWidgetState extends State<PowerWattageWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic iconColor = Colors.blue;

    if (widget.watt < 900) {
      iconColor = Colors.blue;
    } else if (widget.watt >= 900 && widget.watt <= 2000) {
      iconColor = Colors.blueAccent;
    } else if (widget.watt > 2000 && widget.watt <= 5000) {
      iconColor = Colors.green;
    } else if (widget.watt > 5000 && widget.watt <= 10000) {
      iconColor = Colors.lightGreen;
    } else if (widget.watt > 10000 && widget.watt <= 15000) {
      iconColor = Colors.red;
    } else {
      iconColor = Colors.yellow;
    }

    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(16.0),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Wattage',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.wind_power_outlined,
                        color: iconColor,
                        size: 40,
                      ), // Customize icon & color
                    ),
                    TextSpan(
                      text: " ${widget.watt.toStringAsFixed(2)}W",
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
                  label: 'Min', value: "${widget.min.toStringAsFixed(2)}W"),
              KeyValueWidget(
                  label: 'Max', value: "${widget.max.toStringAsFixed(2)}W"),
              KeyValueWidget(
                  label: 'Average',
                  value: "${widget.average.toStringAsFixed(2)}W"),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
