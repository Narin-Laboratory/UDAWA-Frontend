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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "AI Interpreter",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w100,
              ),
            ),
            if (widget.message.isNotEmpty)
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.message,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: widget.onPressed, // Call the callback function
              icon: Icon(Icons.refresh),
              label: const Text(
                "Generate",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
