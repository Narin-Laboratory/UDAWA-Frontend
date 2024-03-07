// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class KeyValueWidget extends StatefulWidget {
  final String label;
  final dynamic value;

  const KeyValueWidget({super.key, required this.label, required this.value});

  @override
  _KeyValueWidgetState createState() => _KeyValueWidgetState();
}

class _KeyValueWidgetState extends State<KeyValueWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Card(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Text("${widget.label}: ",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Text(widget.value.toString()),
          ],
        ),
      )),
    );
  }
}
