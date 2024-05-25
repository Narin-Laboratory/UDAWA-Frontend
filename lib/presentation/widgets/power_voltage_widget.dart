import 'package:flutter/material.dart';
import 'package:udawa/presentation/widgets/key_value_widget.dart';

class PowerVoltageWidget extends StatefulWidget {
  final double volt;
  final double min;
  final double max;
  final double average;

  const PowerVoltageWidget(
      {Key? key,
      required this.volt,
      required this.min,
      required this.max,
      required this.average})
      : super(key: key);

  @override
  _PowerVoltageWidgetState createState() => _PowerVoltageWidgetState();
}

class _PowerVoltageWidgetState extends State<PowerVoltageWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic iconColor = Colors.blue;

    if (widget.volt < 5) {
      iconColor = Color.fromARGB(255, 107, 30, 0);
    } else if (widget.volt >= 5 && widget.volt <= 8) {
      iconColor = Color.fromARGB(255, 158, 19, 19);
    } else if (widget.volt > 8 && widget.volt <= 12) {
      iconColor = Color.fromARGB(255, 19, 21, 158);
    } else if (widget.volt > 12 && widget.volt <= 14) {
      iconColor = Color.fromARGB(255, 19, 158, 19);
    } else if (widget.volt > 14 && widget.volt <= 18) {
      iconColor = Color.fromARGB(255, 255, 0, 0);
    } else {
      iconColor = Color.fromARGB(255, 251, 255, 0);
    }

    return Container(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Voltage',
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
                        Icons.power_sharp,
                        color: iconColor,
                        size: 40,
                      ), // Customize icon & color
                    ),
                    TextSpan(
                      text: " ${widget.volt.toStringAsFixed(2)}V",
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
                  label: 'Min', value: "${widget.min.toStringAsFixed(2)}V"),
              KeyValueWidget(
                  label: 'Max', value: "${widget.max.toStringAsFixed(2)}V"),
              KeyValueWidget(
                  label: 'Average',
                  value: "${widget.average.toStringAsFixed(2)}V"),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
