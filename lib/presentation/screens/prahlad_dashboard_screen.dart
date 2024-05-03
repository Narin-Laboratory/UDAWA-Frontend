import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udawa/bloc/websocket_bloc.dart';
import 'package:udawa/models/device_attributes_model.dart';
import 'package:udawa/models/device_config_model.dart';
import 'package:udawa/models/device_telemetry_model.dart';
import 'package:udawa/models/power_sensor_model.dart';
import 'package:udawa/models/ec_sensor_model.dart';
import 'package:udawa/models/temperature_sensor_model.dart';
import 'package:udawa/presentation/screens/login_screen.dart';
import 'package:udawa/presentation/widgets/appbar_widget.dart';
import 'package:udawa/presentation/widgets/generic_line_chart_widget.dart';
import 'package:udawa/presentation/widgets/power_amperage_widget.dart';
import 'package:udawa/presentation/widgets/power_voltage_widget.dart';
import 'package:udawa/presentation/widgets/power_wattage_widget.dart';
import 'package:udawa/presentation/widgets/water_ec_widget.dart';
import 'package:udawa/presentation/widgets/water_temperature_widget.dart';

class PrahladDashboardScreen extends StatefulWidget {
  const PrahladDashboardScreen({super.key});

  @override
  State<PrahladDashboardScreen> createState() => _PrahladDashboardScreenState();
}

class _PrahladDashboardScreenState extends State<PrahladDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Add a key

  DeviceTelemetry devTel = DeviceTelemetry();
  DeviceAttributes attr = DeviceAttributes();
  DeviceConfig cfg = DeviceConfig();
  TemperatureSensor temperatureSensor = TemperatureSensor();
  ECSensor tdsSensor = ECSensor();
  PowerSensor powerSensor = PowerSensor();

  List<FlSpot> celsiusData = [];
  List<FlSpot> celsiusRawData = [];
  List<FlSpot> tdsData = [];
  List<FlSpot> tdsRawData = [];

  List<FlSpot> voltData = [];
  List<FlSpot> voltRawData = [];

  List<FlSpot> ampData = [];
  List<FlSpot> ampRawData = [];

  List<FlSpot> wattData = [];
  List<FlSpot> wattRawData = [];

  double celsMax = 0.0;
  double celsMin = -100.0;

  double tdsMax = 0.0;
  double tdsMin = -100.0;

  double voltMax = 0.0;
  double voltMin = -100.0;

  double ampMax = 0.0;
  double ampMin = -100.0;

  double wattMax = 0.0;
  double wattMin = -100.0;

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

            if (temperatureSensor.celsRaw > celsMax) {
              celsMax = temperatureSensor.celsRaw;
            }
            if (temperatureSensor.celsRaw < celsMin || celsMin == -100.0) {
              celsMin = temperatureSensor.celsRaw;
            }

            if (celsiusData.length >= 60) {
              celsiusData.removeAt(0); // Remove oldest point (FIFO approach)
              celsiusRawData.removeAt(0);
            } else {
              celsiusData.add(FlSpot(state.temperatureSensor.ts.toDouble(),
                  state.temperatureSensor.cels));
              celsiusRawData.add(FlSpot(state.temperatureSensor.ts.toDouble(),
                  state.temperatureSensor.celsRaw));
            }
          });
        } else if (state is WebSocketMessageReadyECSensor) {
          setState(() {
            tdsSensor = state.ecSensor;

            if (tdsSensor.ecRaw > tdsMax) {
              tdsMax = tdsSensor.ecRaw;
            }
            if (tdsSensor.ecRaw < tdsMin || tdsMin == -100.0) {
              tdsMin = tdsSensor.ecRaw;
            }

            if (tdsData.length >= 60) {
              tdsData.removeAt(0); // Remove oldest point (FIFO approach)
              tdsRawData.removeAt(0);
            } else {
              tdsData
                  .add(FlSpot(state.ecSensor.ts.toDouble(), state.ecSensor.ec));
              tdsRawData.add(
                  FlSpot(state.ecSensor.ts.toDouble(), state.ecSensor.ecRaw));
            }
          });
        } else if (state is WebSocketMessageReadyPowerSensor) {
          setState(() {
            powerSensor = state.powerSensor;

            if (powerSensor.voltRaw > voltMax) {
              voltMax = powerSensor.voltRaw;
            }
            if (powerSensor.voltRaw < voltMin || voltMin == -100.0) {
              voltMin = powerSensor.voltRaw;
            }

            if (voltData.length >= 60) {
              voltData.removeAt(0);
              voltRawData.removeAt(0);
            } else {
              voltData.add(FlSpot(
                  state.powerSensor.ts.toDouble(), state.powerSensor.volt));
              voltRawData.add(FlSpot(
                  state.powerSensor.ts.toDouble(), state.powerSensor.voltRaw));
            }

            if (powerSensor.ampRaw > ampMax) {
              ampMax = powerSensor.ampRaw;
            }
            if (powerSensor.ampRaw < ampMin || ampMin == -100.0) {
              ampMin = powerSensor.ampRaw;
            }

            if (ampData.length >= 60) {
              ampData.removeAt(0);
              ampRawData.removeAt(0);
            } else {
              ampData.add(FlSpot(
                  state.powerSensor.ts.toDouble(), state.powerSensor.amp));
              ampRawData.add(FlSpot(
                  state.powerSensor.ts.toDouble(), state.powerSensor.ampRaw));
            }

            if (powerSensor.wattRaw > wattMax) {
              wattMax = powerSensor.wattRaw;
            }
            if (powerSensor.wattRaw < wattMin || wattMin == -100.0) {
              wattMin = powerSensor.wattRaw;
            }

            if (wattData.length >= 60) {
              wattData.removeAt(0);
              wattRawData.removeAt(0);
            } else {
              wattData.add(FlSpot(
                  state.powerSensor.ts.toDouble(), state.powerSensor.watt));
              wattRawData.add(FlSpot(
                  state.powerSensor.ts.toDouble(), state.powerSensor.wattRaw));
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
          title: "UDAWA Prahlad",
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
                  celsiusRaw: temperatureSensor.celsRaw,
                  min: celsMin,
                  max: celsMax,
                  average: temperatureSensor.celsAvg),
              GenericLineChart(
                data: [celsiusData, celsiusRawData],
                title: "Celsius",
                yAxisLabel: "Temp (°C)",
                minY: double.parse((celsMin - 1).toStringAsFixed(2)),
                maxY: double.parse((celsMax + 1).toStringAsFixed(2)),
              ),
              WaterECWidget(
                  ec: tdsSensor.ec,
                  ecRaw: tdsSensor.ecRaw,
                  min: tdsMin,
                  max: tdsMax,
                  average: tdsSensor.ecAvg),
              GenericLineChart(
                data: [tdsData, tdsRawData],
                title: "TDS",
                yAxisLabel: "TDS (ppm)",
                minY: double.parse((tdsMin - 2).toStringAsFixed(2)),
                maxY: double.parse((tdsMax + 2).toStringAsFixed(2)),
              ),
              PowerVoltageWidget(
                  volt: powerSensor.volt,
                  min: voltMin,
                  max: voltMax,
                  average: powerSensor.voltAvg),
              GenericLineChart(
                data: [voltData, voltRawData],
                title: "Voltage",
                yAxisLabel: "Volt (v)",
                minY: double.parse((voltMin - 2).toStringAsFixed(2)),
                maxY: double.parse((voltMax + 2).toStringAsFixed(2)),
              ),
              PowerAmperageWidget(
                  amp: powerSensor.amp,
                  min: ampMin,
                  max: ampMax,
                  average: powerSensor.ampAvg),
              GenericLineChart(
                data: [ampData, ampRawData],
                title: "Amperage",
                yAxisLabel: "mili Ampere (mA)",
                minY: double.parse((ampMin - 2).toStringAsFixed(2)),
                maxY: double.parse((ampMax + 2).toStringAsFixed(2)),
              ),
              PowerWattageWidget(
                  watt: powerSensor.watt,
                  min: wattMin,
                  max: wattMax,
                  average: powerSensor.wattAvg),
              GenericLineChart(
                data: [wattData, wattRawData],
                title: "Wattage",
                yAxisLabel: "Watt (W)",
                minY: double.parse((wattMin - 2).toStringAsFixed(2)),
                maxY: double.parse((wattMax + 2).toStringAsFixed(2)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
