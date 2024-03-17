import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udawa/bloc/auth_bloc.dart';
import 'package:udawa/bloc/websocket_bloc.dart';
import 'package:udawa/models/mdns_device_model.dart';
import 'package:udawa/presentation/screens/damodar_dashboard_screen.dart';
import 'package:udawa/presentation/screens/prahlad_dashboard_screen.dart';
import 'package:udawa/presentation/screens/vanilla_dashboard_screen.dart';
import 'package:udawa/presentation/widgets/login_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final webApiKeyController = TextEditingController();
  final deviceIpAddressController = TextEditingController();
  String _textLog = '';

  bool _isConnectButtonDisabled = false;

  void _handleConnectButtonClick() {
    if (!_isConnectButtonDisabled) {
      // Disable the button
      /*setState(() {
        _isConnectButtonDisabled = true;
      });*/

      // Perform your action here
      // For example, make network request, process data, etc.

      context.read<AuthBloc>().add(AuthLocalOnRequested(
          ip: deviceIpAddressController.text,
          webApiKey: webApiKeyController.text));

      // After the action is completed, enable the button again
      /*Future.delayed(const Duration(seconds: 10), () {
        setState(() {
          _isConnectButtonDisabled = false;
        });
      });*/
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    webApiKeyController.dispose();
    deviceIpAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*setState(() {
      webApiKeyController.text = "default";
      deviceIpAddressController.text = "192.168.99.180";
    });*/

    return BlocConsumer<WebSocketBloc, WebSocketState>(
      listener: (context, state) {
        if (state is WebSocketLocalAuthReceived) {
          context
              .read<AuthBloc>()
              .add(AuthLocalOnWebSocketLocalAuthReceived(model: state.model));
        }
        if (state is WebSocketError) {
          setState(() {
            _textLog = state.error;
            _isConnectButtonDisabled = false;
          });
          context.read<AuthBloc>().add(AuthLocalOnError(error: state.error));
        }
        if (state is WebSocketLocalAuthError) {
          setState(() {
            _textLog = state.message!['status']!['msg'];
            _isConnectButtonDisabled = false;
          });
          context
              .read<AuthBloc>()
              .add(AuthLocalOnError(error: state.message!['status']!['msg']));
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLocalError) {
              setState(() {
                _textLog = state.error;
                _isConnectButtonDisabled = false;
              });
            }

            if (state is AuthLocalOnProcess) {
              setState(() {
                _textLog = state.message;
                _isConnectButtonDisabled = true;
              });
            }

            if (state is AuthLocalSuccess) {
              setState(() {
                _textLog = "Connected! Redirecting to dashboard...";
              });

              final model = state.model?['status']?['model'] ?? -1;

              if (model == 'Vanilla') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VanillaDashboardScreen()),
                  (route) => false,
                );
              } else if (model == 'Gadadar') {
              } else if (model == 'Damodar') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DamodarDashboardScreen()),
                  (route) => false,
                );
              } else if (model == 'Sudarsan') {
              } else if (model == 'Prahlad') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrahladDashboardScreen()),
                  (route) => false,
                );
              }
            }
          },
          builder: (context, state) {
            return Scaffold(
                // Assuming you want to position it within a standard screen layout
                body: LayoutBuilder(builder: (context, constraints) {
              double maxWidth =
                  constraints.maxWidth > 800 ? 800 : constraints.maxWidth;
              return Center(
                // Center the content within the Scaffold's body
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center vertically
                        children: [
                          SizedBox(
                            width: 90.0, // Set your desired width
                            height: 90.0, // Set your desired height
                            child: Image.asset('assets/images/logo.png'),
                          ),
                          const SizedBox(height: 10),
                          const Text("UDAWA Smart System",
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 22,
                                color: Colors.green,
                              )),
                          const SizedBox(height: 15),
                          LoginField(
                            labelText: "Device IP Address",
                            onChanged: (value) {},
                            controller: deviceIpAddressController,
                          ),
                          const SizedBox(height: 15),
                          LoginField(
                            labelText: "Web Api Key",
                            obscureText: true,
                            onChanged: (value) {},
                            controller: webApiKeyController,
                          ),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton.icon(
                                    onPressed: kIsWeb
                                        ? null
                                        : () async {
                                            final selectedDevice =
                                                await showDialog<MdnsDevice>(
                                              context: context,
                                              builder: (context) =>
                                                  const SelectionPopup(),
                                            );

                                            if (selectedDevice != null) {
                                              // Do something with the selectedItem
                                              deviceIpAddressController.text =
                                                  selectedDevice
                                                      .address.address;
                                            }
                                          },
                                    icon: const Icon(Icons.search),
                                    label: const Text("Scan")),
                              ),
                              const SizedBox(
                                  width: 10), // Add spacing between buttons
                              Expanded(
                                child: ElevatedButton.icon(
                                    onPressed: _isConnectButtonDisabled
                                        ? null
                                        : _handleConnectButtonClick,
                                    icon: const Icon(
                                        Icons.connect_without_contact_sharp),
                                    label: const Text("Connect")),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          if (_textLog
                              .isNotEmpty) // Check if there's a log message
                            SizedBox(
                              height: 50,
                              child: Center(
                                // Add the Center widget here
                                child: Row(
                                  children: [
                                    if (state is AuthLocalOnProcess)
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      ),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text(_textLog)),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
          },
        ));
      },
    );
  }
}

class SelectionPopup extends StatefulWidget {
  const SelectionPopup({super.key});

  @override
  SelectionPopupState createState() => SelectionPopupState();
}

class SelectionPopupState extends State<SelectionPopup> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthDeviceScannerOnRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthDeviceScannerStarted) {
          return const AlertDialog(
              title: Text("Device Scanner"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [Text("Starting Device Scanner...")],
              ));
        } else if (state is AuthDeviceScannerOnProcess) {
          return AlertDialog(
              title: const Text("Scanning in Progress"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "Found: ${state.mdnsDevice.name} at ${state.mdnsDevice.address.address}")
                ],
              ));
        } else if (state is AuthDeviceScannerFinished) {
          return AlertDialog(
            title: const Text("Select a Device"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final device in state.mdnsDeviceList)
                  ListTile(
                    title: Text("${device.name} - ${device.address.address}"),
                    onTap: () {
                      Navigator.pop(context, device);
                    },
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthDeviceScannerOnRequested());
                },
                child: const Text('Rescan'),
              ),
            ],
          );
        } else {
          return const AlertDialog(
              title: Text("Select a Device"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [Text("Unknown error has occured!")],
              ));
        }
      },
    );
  }
}
