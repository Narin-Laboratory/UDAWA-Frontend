import 'package:flutter/material.dart';
import 'package:udawa/presentation/widgets/key_value_widget.dart';

class WaterTDSWidget extends StatefulWidget {
  final double tds;
  final double tdsRaw;
  final double min;
  final double max;
  final double average;

  const WaterTDSWidget(
      {Key? key,
      required this.tds,
      this.tdsRaw = 0.0,
      required this.min,
      required this.max,
      required this.average})
      : super(key: key);

  @override
  _WaterTDSWidgetState createState() => _WaterTDSWidgetState();
}

class _WaterTDSWidgetState extends State<WaterTDSWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic iconColor = Colors.blue;

    if (widget.tds < 100) {
      iconColor = Colors.lightBlueAccent;
    } else if (widget.tds >= 100 && widget.tds <= 200) {
      iconColor = Colors.lightBlue;
    } else if (widget.tds > 200 && widget.tds <= 400) {
      iconColor = Colors.lightGreen;
    } else if (widget.tds > 400 && widget.tds <= 600) {
      iconColor = Colors.green;
    } else if (widget.tds > 600 && widget.tds <= 800) {
      iconColor = Colors.lime;
    } else if (widget.tds > 800 && widget.tds <= 1200) {
      iconColor = Colors.pink;
    } else if (widget.tds > 1200) {
      iconColor = Colors.purple;
    }

    return Padding(
      padding: const EdgeInsets.all(0), // Example padding
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Water TDS", // Display current slider value
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
                      Icons.water,
                      color: iconColor,
                      size: 40,
                    ), // Customize icon & color
                  ),
                  TextSpan(
                    text: " ${widget.tds.toStringAsFixed(2)}ppm",
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
                label: 'Min', value: "${widget.min.toStringAsFixed(2)}ppm"),
            KeyValueWidget(
                label: 'Max', value: "${widget.max.toStringAsFixed(2)}ppm"),
            KeyValueWidget(
                label: 'Average',
                value: "${widget.average.toStringAsFixed(2)}ppm"),
            widget.tdsRaw != 0.0
                ? KeyValueWidget(
                    label: 'Raw',
                    value: "${widget.tdsRaw.toStringAsFixed(2)}ppm")
                : const Text(""),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
