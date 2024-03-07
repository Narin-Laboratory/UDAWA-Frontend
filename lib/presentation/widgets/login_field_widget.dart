import 'package:flutter/material.dart';

class LoginField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const LoginField({
    super.key,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    required this.onChanged,
    required this.controller,
  });

  @override
  LoginFieldState createState() => LoginFieldState();
}

class LoginFieldState extends State<LoginField> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
      ),
    );
  }
}
