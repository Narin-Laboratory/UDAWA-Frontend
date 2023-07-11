import 'package:flutter/material.dart';
import 'package:nsd/nsd.dart';
import 'websocket_service.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

const String serviceTypeDiscover = '_http._tcp';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _wsService = WebsocketService();
  final _devices = <Discovery>[];
  String? _selectedDevice;
  String _password = '';

  @override
  void initState() {
    super.initState();
    addDiscovery();
  }

  Future<void> addDiscovery() async {
    final discovery = await startDiscovery(serviceTypeDiscover);
    setState(() {
      _devices.add(discovery);
    });
  }

  Future<void> dismissDiscovery(Discovery discovery) async {
    setState(() {
      /// remove fast, without confirmation, to avoid "onDismissed" error.
      _devices.remove(discovery);
    });

    await stopDiscovery(discovery);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          DropdownButtonFormField(
            value: _selectedDevice,
            items: _devices.map((String device) {
              return DropdownMenuItem(
                value: device,
                child: Text(device),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedDevice = newValue!;
              });
            },
            decoration: InputDecoration(
              labelText: 'Select a device',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a device';
              }
              return null;
            },
          ),
          TextFormField(
            obscureText: true,
            onChanged: (value) {
              _password = value;
            },
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // No need to call initialize() here,
                // as it was already called in the onResolved() callback
                _wsService.messages.listen((message) {
                  var msg = jsonDecode(message);
                  // Handle your message here
                });
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
