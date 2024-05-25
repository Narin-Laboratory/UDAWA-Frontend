import 'package:flutter/material.dart';

class AICardWidget extends StatefulWidget {
  final String message;
  final VoidCallback onPressed;

  const AICardWidget({
    Key? key,
    required this.onPressed,
    this.message = "",
  }) : super(key: key);

  @override
  _AICardWidgetState createState() => _AICardWidgetState();
}

class _AICardWidgetState extends State<AICardWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic iconColor = Colors.blue;

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
                'AI Interpreter',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              if (widget.message.isNotEmpty) const SizedBox(height: 16.0),
              Text(
                widget.message,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: widget.onPressed, // Call the callback function
                icon: Icon(Icons.refresh),
                label: const Text(
                  "Analyze",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
