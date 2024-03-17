import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udawa/bloc/websocket_bloc.dart';
import 'package:udawa/models/device_attributes_model.dart';
import 'package:udawa/models/device_config_model.dart';
import 'package:udawa/models/device_telemetry_model.dart';
import 'package:udawa/models/tds_sensor_model.dart';
import 'package:udawa/models/temperature_sensor_model.dart';
import 'package:udawa/presentation/screens/login_screen.dart';
import 'package:udawa/presentation/widgets/appbar_widget.dart';
import 'package:udawa/presentation/widgets/generic_line_chart_widget.dart';
import 'package:udawa/presentation/widgets/water_tds_widget.dart';
import 'package:udawa/presentation/widgets/water_temperature_widget.dart';

class DamodarDashboardScreen extends StatefulWidget {
  const DamodarDashboardScreen({super.key});

  @override
  State<DamodarDashboardScreen> createState() => _DamodarDashboardScreenState();
}

class _DamodarDashboardScreenState extends State<DamodarDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Add a key

  DeviceTelemetry devTel = DeviceTelemetry();
  DeviceAttributes attr = DeviceAttributes();
  DeviceConfig cfg = DeviceConfig();
  TemperatureSensor temperatureSensor = TemperatureSensor();
  TDSSensor tdsSensor = TDSSensor();

  List<FlSpot> celsiusData = [];
  List<FlSpot> celsiusRawData = [];
  List<FlSpot> tdsData = [];
  List<FlSpot> tdsRawData = [];

  double celsMax = 0.0;
  double celsMin = -100.0;

  double tdsMax = 0.0;
  double tdsMin = -100.0;

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
        } else if (state is WebSocketMessageReadyTemperatureSensor) {
          setState(() {
            temperatureSensor = state.temperatureSensor;

            if (temperatureSensor.cels > celsMax) {
              celsMax = temperatureSensor.cels;
            }
            if (temperatureSensor.cels < celsMin || celsMin == -100.0) {
              celsMin = temperatureSensor.cels;
            }

            if (celsiusData.length >= 240) {
              celsiusData.removeAt(0); // Remove oldest point (FIFO approach)
              celsiusRawData.removeAt(0);
            } else {
              celsiusData.add(FlSpot(state.temperatureSensor.ts.toDouble(),
                  state.temperatureSensor.cels));
              celsiusRawData.add(FlSpot(state.temperatureSensor.ts.toDouble(),
                  state.temperatureSensor.celsRaw));
            }
          });
        } else if (state is WebSocketMessageReadyTDSSensor) {
          setState(() {
            tdsSensor = state.tdsSensor;

            if (tdsSensor.ppm > tdsMax) {
              tdsMax = tdsSensor.ppm;
            }
            if (tdsSensor.ppm < tdsMin || tdsMin == -100.0) {
              tdsMin = tdsSensor.ppm;
            }

            if (tdsData.length >= 240) {
              tdsData.removeAt(0); // Remove oldest point (FIFO approach)
              tdsRawData.removeAt(0);
            } else {
              tdsData.add(
                  FlSpot(state.tdsSensor.ts.toDouble(), state.tdsSensor.ppm));
              tdsRawData.add(FlSpot(
                  state.tdsSensor.ts.toDouble(), state.tdsSensor.ppmRaw));
            }
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
                  celsius: temperatureSensor.cels,
                  min: celsMin,
                  max: celsMax,
                  average: temperatureSensor.celsAvg),
              GenericLineChart(
                data: [celsiusData, celsiusRawData],
                title: "Celsius",
                yAxisLabel: "Temp (°C)",
                minY: double.parse((celsMin - 2).toStringAsFixed(2)),
                maxY: double.parse((celsMax + 2).toStringAsFixed(2)),
              ),
              WaterTDSWidget(
                  tds: tdsSensor.ppm,
                  min: tdsMin,
                  max: tdsMax,
                  average: tdsSensor.ppmAvg),
              GenericLineChart(
                data: [tdsData, tdsRawData],
                title: "TDS",
                yAxisLabel: "TDS (ppm)",
                minY: double.parse((tdsMin - 5).toStringAsFixed(2)),
                maxY: double.parse((tdsMax + 5).toStringAsFixed(2)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
