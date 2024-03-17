import 'package:flutter/material.dart';
import 'package:udawa/presentation/widgets/key_value_widget.dart';

class PowerAmperageWidget extends StatefulWidget {
  final double amp;
  final double min;
  final double max;
  final double average;

  const PowerAmperageWidget(
      {Key? key,
      required this.amp,
      required this.min,
      required this.max,
      required this.average})
      : super(key: key);

  @override
  _PowerAmperageWidgetState createState() => _PowerAmperageWidgetState();
}

class _PowerAmperageWidgetState extends State<PowerAmperageWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic iconColor = Colors.blue;

    if (widget.amp < 90) {
      iconColor = Colors.blue;
    } else if (widget.amp >= 90 && widget.amp <= 200) {
      iconColor = Colors.blueAccent;
    } else if (widget.amp > 200 && widget.amp <= 500) {
      iconColor = Colors.green;
    } else if (widget.amp > 500 && widget.amp <= 1000) {
      iconColor = Colors.lightGreen;
    } else if (widget.amp > 1000 && widget.amp <= 1500) {
      iconColor = Colors.red;
    } else {
      iconColor = Colors.yellow;
    }

    return Padding(
      padding: const EdgeInsets.all(0), // Example padding
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Power Amperage", // Display current slider value
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
                      Icons.flash_auto,
                      color: iconColor,
                      size: 40,
                    ), // Customize icon & color
                  ),
                  TextSpan(
                    text: " ${widget.amp.toStringAsFixed(2)}mA",
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
                label: 'Min', value: "${widget.min.toStringAsFixed(2)}mA"),
            KeyValueWidget(
                label: 'Max', value: "${widget.max.toStringAsFixed(2)}mA"),
            KeyValueWidget(
                label: 'Average',
                value: "${widget.average.toStringAsFixed(2)}mA"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
