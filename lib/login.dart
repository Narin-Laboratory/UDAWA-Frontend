import 'package:flutter/material.dart';
import 'package:multicast_dns/multicast_dns.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  List<DropdownMenuItem> _devices = [
    DropdownMenuItem(
      value: "Unavailable",
      child: Text("Unavailable"),
    )
  ];
  String _selectedOption = "Unavailable";

  void _changeOption(String option) {
    setState(() {
      _selectedOption = option;
      _usernameController.text = _selectedOption;
    });
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
              icon: Icon(Icons.keyboard_arrow_down),
              items: _devices!,
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
                _usernameController.clear();
                _passwordController.clear();
                _scanMDNS();
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('NEXT'),
            ),
          ],
        ),
      ),
    );
  }

  void _scanMDNS() async {
    String serviceType = '_http._tcp';
    final MDnsClient client = MDnsClient();
    await client.start();

    try {
      _devices.clear();
      List<String> _marker = [];
      await for (final PtrResourceRecord ptr
          in client.lookup<PtrResourceRecord>(
              ResourceRecordQuery.serverPointer(serviceType))) {
        print('PTR: ${ptr.toString()}');

        await for (final SrvResourceRecord srv
            in client.lookup<SrvResourceRecord>(
                ResourceRecordQuery.service(ptr.domainName))) {
          print('SRV target: ${srv.target} port: ${srv.port}');

          await for (final IPAddressResourceRecord ip
              in client.lookup<IPAddressResourceRecord>(
                  ResourceRecordQuery.addressIPv4(srv.target))) {
            print('IP: ${ip.address.address}');

            bool exists = _marker.contains(srv.target);
            if (!exists) {
              _marker.add(srv.target);
              _devices.add(DropdownMenuItem(
                value: ip.address.address,
                child: Text(srv.target),
              ));
            }
          }
        }
      }
      setState(() {});
    } finally {
      client.stop();
    }
  }
}
