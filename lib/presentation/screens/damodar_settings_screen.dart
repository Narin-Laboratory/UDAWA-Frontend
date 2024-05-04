import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udawa/bloc/damodar_ai_analyzer_bloc.dart';
import 'package:udawa/bloc/damodar_settings_bloc.dart';
import 'package:udawa/bloc/websocket_bloc.dart';

import 'package:udawa/models/device_attributes_model.dart';
import 'package:udawa/models/device_config_model.dart';
import 'package:udawa/models/device_telemetry_model.dart';

import 'package:udawa/presentation/screens/damodar_analytics_screen.dart';
import 'package:udawa/presentation/screens/damodar_dashboard_screen.dart';

import 'package:udawa/presentation/widgets/appbar_widget.dart';

class DamodarSettingsScreen extends StatefulWidget {
  const DamodarSettingsScreen({super.key});

  @override
  State<DamodarSettingsScreen> createState() => _DamodarSettingsScreenState();
}

class _DamodarSettingsScreenState extends State<DamodarSettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Add a key

  DeviceTelemetry devTel = DeviceTelemetry();
  DeviceAttributes attr = DeviceAttributes();
  DeviceConfig cfg = DeviceConfig();

  TextEditingController _ssidController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _hostnameController = TextEditingController();
  TextEditingController _cultivationTechnology = TextEditingController();
  TextEditingController _plantType = TextEditingController();
  TextEditingController _plantAge = TextEditingController();
  TextEditingController _rawWaterEC = TextEditingController();
  TextEditingController _waterSource = TextEditingController();

  bool _isGenerateButtonDisabled = false;

  void _saveSettings() {}

  void _handleGenerateButtonClick() {
    if (!_isGenerateButtonDisabled) {
      // Disable the button
      /*setState(() {
        _isConnectButtonDisabled = true;
      });*/

      // Perform your action here
      // For example, make network request, process data, etc.

      dynamic command = {"cmd": "DamodarAIAnalyzer"};
      context
          .read<DamodarAIAnalyzerBloc>()
          .add(DamodarAIAnalyzerRequest(command: command));

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

    dynamic command = {
      "cmd": "GetGHParams",
    };
    context
        .read<DamodarSettingsBloc>()
        .add(DamodarSettingsRequest(command: command));
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    _hostnameController.dispose();
    _cultivationTechnology.dispose();
    _plantType.dispose();
    _plantAge.dispose();
    _rawWaterEC.dispose();
    _waterSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WebSocketBloc, WebSocketState>(
      listener: (context, state) {
        if (state is WebSocketMessageReadyDeviceConfig) {
          setState(() {
            cfg = state.config;
            _hostnameController.text = state.config.hname;
          });

          context
              .read<DamodarSettingsBloc>()
              .add(DamodarSettingsResponse(deviceConfig: state.config));
        } else if (state is WebSocketMessageReadyDeviceTelemetry) {
          setState(() {
            devTel = state.telemetry;
          });
        } else if (state is WebSocketMessageReadyGHParams) {
          setState(() {
            _cultivationTechnology.text = state.ghParams.cultivationTechnology;
            _plantType.text = state.ghParams.plantType;
            _plantAge.text = ((DateTime.now().millisecondsSinceEpoch -
                        state.ghParams.plantTransplantingTS) /
                    (1000 * 60 * 60 * 24))
                .floor()
                .toString();
            _waterSource.text = state.ghParams.waterSource;
            _rawWaterEC.text = state.ghParams.rawWaterEC.toString();
          });
        }
      },
      child: BlocConsumer<DamodarSettingsBloc, DamodarSettingsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            key: _scaffoldKey, // Assign the key
            appBar: AppBarWidget(
              scaffoldKey: _scaffoldKey,
              title: "UDAWA Damodar",
              uptime: " UT ${devTel.uptime.toString()}",
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text('UDAWA Menu'),
                  ),
                  ListTile(
                    title: const Text('Dashboard'),
                    onTap: () {
                      // Handle Dashboard navigation (likely do nothing here)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DamodarDashboardScreen()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Analytics'),
                    onTap: () {
                      // Navigate to Analytics screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DamodarAnalyticsScreen()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Settings'),
                    onTap: () {
                      // Navigate to Settings screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DamodarSettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              // To handle potential overflow
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.all(16.0),
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'WiFi Settings',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _ssidController,
                            decoration: InputDecoration(
                              labelText: 'WiFi SSID',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'WiFi Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _hostnameController,
                            decoration: InputDecoration(
                              labelText: 'Local Hostname',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: _saveSettings,
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(16.0),
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Global Greenhouse Settings',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _cultivationTechnology,
                            decoration: InputDecoration(
                              labelText: 'Cultivation Technology',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _plantType,
                            decoration: InputDecoration(
                              labelText: 'Plant Type',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _plantAge,
                            decoration: InputDecoration(
                              labelText: 'Plant Age (days)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _rawWaterEC,
                            decoration: InputDecoration(
                              labelText: 'Raw Water EC (μS/cm)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _waterSource,
                            decoration: InputDecoration(
                              labelText: 'Water Source',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: _saveSettings,
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
