import 'package:flutter/material.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'dart:convert';
import 'websocket.dart';

class LoginPage extends StatefulWidget {
  final WebSocketService wsService;

  const LoginPage({Key? key, required this.wsService}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController(text: "gadadar108");

  List<DropdownMenuItem<String>> _devices = [
    const DropdownMenuItem(
      value: "",
      child: Text("Manual Input"),
    )
  ];
  String _selectedOption = "";

  void _changeOption(String option) {
    setState(() {
      _selectedOption = option;
      _usernameController.text = _selectedOption;
    });
  }

  void _scanMDNS() async {
    final serviceType = '_http._tcp';
    final MDnsClient client = MDnsClient();
    await client.start();

    try {
      await for (final ptr in client.lookup<PtrResourceRecord>(
          ResourceRecordQuery.serverPointer(serviceType))) {
        await for (final srv in client.lookup<SrvResourceRecord>(
            ResourceRecordQuery.service(ptr.domainName))) {
          await for (final ip in client.lookup<IPAddressResourceRecord>(
              ResourceRecordQuery.addressIPv4(srv.target))) {
            if (!_devices.any((device) => device.value == ip.address.address)) {
              setState(() {
                _devices.add(DropdownMenuItem(
                  value: ip.address.address,
                  child: Text(srv.target),
                ));
              });
            }
          }
        }
      }
    } finally {
      client.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/images/logo.png', scale: 4),
                const SizedBox(height: 16.0),
                const Text('UDAWA Smart System'),
              ],
            ),
            const SizedBox(height: 120.0),
            DropdownButton(
              value: _selectedOption,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: _devices,
              onChanged: (option) {
                _changeOption(option!);
              },
            ),
            // [Name]
            TextField(
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Username',
              ),
              controller: _usernameController,
            ),
            // Spacer
            const SizedBox(height: 12.0),
            // [Password]
            TextField(
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Password',
              ),
              obscureText: true,
              controller: _passwordController,
            ),
            TextButton(
              child: const Text('SCAN'),
              onPressed: () {
                _devices.clear();
                _devices.add(const DropdownMenuItem(
                  value: '',
                  child: Text('Manual Input'),
                ));
                _scanMDNS();
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_usernameController.text == '') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Server address is empty.'),
                  ));
                  return;
                }

                if (_passwordController.text == '') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Service key is empty.'),
                  ));
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Connecting to: ${_usernameController.text}'),
                ));

                widget.wsService.connect(
                  serverUrl: _usernameController.text,
                  apiKey: _passwordController.text,
                );

                widget.wsService.events.listen((event) {
                  if (event.type == WebSocketEventType.message) {
                    final jsonResponse = json.decode(event.data);
                    if (jsonResponse['status'] != null &&
                        jsonResponse['status']['code'] != null &&
                        jsonResponse['status']['code'] == 200 &&
                        jsonResponse['status']['model'] != null &&
                        jsonResponse['status']['model'] == "Gadadar") {
                      Navigator.pushReplacementNamed(context, '/home-gadadar');
                    } else if (jsonResponse['status'] != null &&
                        jsonResponse['status']['code'] != null &&
                        jsonResponse['status']['code'] == 401) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Authentication failed!'),
                      ));
                    }
                  } else if (event.type == WebSocketEventType.error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error occurred: ${event.data}'),
                    ));
                  }
                  // Additional handling can be added for WebSocketEventType.closed if needed
                });
              },
              child: const Text('NEXT'),
            ),
          ],
        ),
      ),
    );
  }
}
