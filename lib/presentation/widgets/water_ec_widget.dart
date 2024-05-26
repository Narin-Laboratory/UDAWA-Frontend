import 'package:flutter/material.dart';
import 'package:udawa/presentation/widgets/key_value_widget.dart';

class WaterECWidget extends StatefulWidget {
  final double ec;
  final double ecRaw;
  final double min;
  final double max;
  final double average;

  const WaterECWidget(
      {Key? key,
      required this.ec,
      this.ecRaw = 0.0,
      required this.min,
      required this.max,
      required this.average})
      : super(key: key);

  @override
  _WaterECWidgetState createState() => _WaterECWidgetState();
}

class _WaterECWidgetState extends State<WaterECWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic iconColor = Colors.blue;

    if (widget.ec < 0.02) {
      iconColor = Colors.lightBlueAccent;
    } else if (widget.ec >= 0.02 && widget.ec <= 0.05) {
      iconColor = Colors.lightBlue;
    } else if (widget.ec > 0.05 && widget.ec <= 0.1) {
      iconColor = Colors.lightGreen;
    } else if (widget.ec > 0.1 && widget.ec <= 0.2) {
      iconColor = Colors.green;
    } else if (widget.ec > 0.2 && widget.ec <= 0.8) {
      iconColor = Colors.lime;
    } else if (widget.ec > 0.8 && widget.ec <= 1.2) {
      iconColor = Colors.pink;
    } else if (widget.ec > 1.2) {
      iconColor = Colors.purple;
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
                'Water EC',
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
                        Icons.water,
                        color: iconColor,
                        size: 40,
                      ), // Customize icon & color
                    ),
                    TextSpan(
                      text: " ${widget.ec.toStringAsFixed(2)} μS/cm",
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
                  label: 'Min',
                  value: "${widget.min.toStringAsFixed(2)} μS/cm"),
              KeyValueWidget(
                  label: 'Max',
                  value: "${widget.max.toStringAsFixed(2)} μS/cm"),
              KeyValueWidget(
                  label: 'Average',
                  value: "${widget.average.toStringAsFixed(2)} μS/cm"),
              widget.ecRaw != 0.0
                  ? KeyValueWidget(
                      label: 'Raw',
                      value: "${widget.ecRaw.toStringAsFixed(2)} μS/cm")
                  : const Text(""),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
