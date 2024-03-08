import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udawa/bloc/websocket_bloc.dart';
import 'package:udawa/models/damodar_sensors_model.dart';
import 'package:udawa/models/device_attributes_model.dart';
import 'package:udawa/models/device_config_model.dart';
import 'package:udawa/models/device_telemetry_model.dart';
import 'package:udawa/presentation/screens/login_screen.dart';
import 'package:udawa/presentation/widgets/appbar_widget.dart';
import 'package:udawa/presentation/widgets/device_attributes_widget.dart';
import 'package:udawa/presentation/widgets/device_config_widget.dart';
import 'package:udawa/presentation/widgets/device_telemetry_widget.dart';
import 'package:udawa/presentation/widgets/generic_line_chart_widget.dart';
import 'package:udawa/presentation/widgets/water_tds_widget.dart';
import 'package:udawa/presentation/widgets/water_temperature_widget.dart';

class DamodarDashboardScreen extends StatefulWidget {
  const DamodarDashboardScreen({super.key});

  @override
  State<DamodarDashboardScreen> createState() => _VanillaDashboardScreenState();
}

class _VanillaDashboardScreenState extends State<DamodarDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Add a key

  DeviceTelemetry devTel = DeviceTelemetry();
  DeviceAttributes attr = DeviceAttributes();
  DeviceConfig cfg = DeviceConfig();
  DamodarSensors damodarSensors = DamodarSensors();

  List<FlSpot> celsiusData = [];
  List<FlSpot> tdsData = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<WebSocketBloc, WebSocketState>(
      listener: (context, state) {
        if (state is WebSocketMessageReadyDeviceAttributes) {
          setState(() {
            attr = state.attributes;
          });
        } else if (state is WebSocketMessageReadyDeviceTelemetry) {
          setState(() {
            devTel = state.telemetry;
          });
        } else if (state is WebSocketMessageReadyDeviceConfig) {
          setState(() {
            cfg = state.config;
          });
        } else if (state is WebSocketMessageReadyDamodarSensors) {
          setState(() {
            damodarSensors = state.damodarSensors;

            if (celsiusData.length >= 240) {
              celsiusData.removeAt(0); // Remove oldest point (FIFO approach)
            }

            if (tdsData.length >= 240) {
              tdsData.removeAt(0); // Remove oldest point (FIFO approach)
            }

            celsiusData.add(FlSpot(
                state.damodarSensors.ts.toDouble(), state.damodarSensors.cels));
            tdsData.add(FlSpot(
                state.damodarSensors.ts.toDouble(), state.damodarSensors.ppm));
          });
        } else if (state is WebSocketDisconnect) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
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
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Analytics'),
                onTap: () {
                  // Navigate to Analytics screen
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Settings'),
                onTap: () {
                  // Navigate to Settings screen
                  Navigator.pop(context);
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
              WaterTemperatureWidget(
                  celsius: damodarSensors.cels,
                  min: damodarSensors.celsMin,
                  max: damodarSensors.celsMax,
                  average: damodarSensors.celsAvg),
              GenericLineChart(
                  data: celsiusData, title: "Celsius", yAxisLabel: "Temp (°C)"),
              WaterTDSWidget(
                  tds: damodarSensors.ppm,
                  min: damodarSensors.ppmMin,
                  max: damodarSensors.ppmMax,
                  average: damodarSensors.ppmAvg),
              GenericLineChart(
                  data: tdsData, title: "TDS", yAxisLabel: "TDS (ppm)"),
            ],
          ),
        ),
      ),
    );
  }
}
