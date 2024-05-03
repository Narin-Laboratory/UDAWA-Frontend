import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udawa/bloc/damodar_ai_analyzer_bloc.dart';
import 'package:udawa/bloc/websocket_bloc.dart';
import 'package:udawa/models/ai_analyzer_model.dart';
import 'package:udawa/models/device_attributes_model.dart';
import 'package:udawa/models/device_config_model.dart';
import 'package:udawa/models/device_telemetry_model.dart';
import 'package:udawa/models/green_house_parameters.dart';
import 'package:udawa/models/ec_sensor_model.dart';
import 'package:udawa/models/temperature_sensor_model.dart';
import 'package:udawa/presentation/screens/login_screen.dart';
import 'package:udawa/presentation/widgets/ai_card_widget.dart';
import 'package:udawa/presentation/widgets/appbar_widget.dart';
import 'package:udawa/presentation/widgets/generic_line_chart_widget.dart';
import 'package:udawa/presentation/widgets/water_ec_widget.dart';
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
  ECSensor ecSensor = ECSensor();
  GreenHouseParameters ghParams = GreenHouseParameters();
  String prompt =
      "Hi Gemini! What do you think about my hydroponic fertigation?";
  DamodarAIAnalyzer damodarAIAnalyzer = DamodarAIAnalyzer();
  int plantAge = 0;

  List<FlSpot> celsiusData = [];
  List<FlSpot> celsiusRawData = [];
  List<FlSpot> ecData = [];
  List<FlSpot> ecRawData = [];

  double celsMax = 0.0;
  double celsMin = -100.0;

  double ecMax = 0.0;
  double ecMin = -100.0;

  bool _isGenerateButtonDisabled = false;

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

    context.read<DamodarAIAnalyzerBloc>().add(DamodarAIAnalyzerIdle());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WebSocketBloc, WebSocketState>(
      listener: (context, state) {
        if (state is WebSocketMessageReadyDamodarAIAnalyzer) {
          setState(() {
            damodarAIAnalyzer = state.damodarAIAnalyzer;
          });

          context.read<DamodarAIAnalyzerBloc>().add(DamodarAIAnalyzerResponse(
              damodarAIAnalyzer: state.damodarAIAnalyzer));
        } else if (state is WebSocketMessageReadyGHParams) {
          setState(() {
            ghParams = state.ghParams;
            plantAge = ((ghParams.plantTransplantingTS -
                        DateTime.now().millisecondsSinceEpoch) /
                    (1000 * 60 * 60 * 24))
                .floor();
          });
        } else if (state is WebSocketMessageReadyDeviceAttributes) {
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
        } else if (state is WebSocketMessageReadyECSensor) {
          setState(() {
            ecSensor = state.ecSensor;

            if (ecSensor.ec > ecMax) {
              ecMax = ecSensor.ec;
            }
            if (ecSensor.ec < ecMin || ecMin == -100.0) {
              ecMin = ecSensor.ec;
            }

            if (ecData.length >= 240) {
              ecData.removeAt(0); // Remove oldest point (FIFO approach)
              ecRawData.removeAt(0);
            } else {
              ecData
                  .add(FlSpot(state.ecSensor.ts.toDouble(), state.ecSensor.ec));
              ecRawData.add(
                  FlSpot(state.ecSensor.ts.toDouble(), state.ecSensor.ecRaw));
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
      child: BlocConsumer<DamodarAIAnalyzerBloc, DamodarAIAnalyzerState>(
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
                  if (state is DamodarAIAnalyzerOnRequest)
                    const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (state is DamodarAIAnalyzerOnResponse)
                    AICardWidget(
                      message: damodarAIAnalyzer.response,
                      onPressed: _handleGenerateButtonClick,
                    ),
                  if (state is DamodarAIAnalyzerOnIdle)
                    AICardWidget(
                      message: prompt,
                      onPressed: _handleGenerateButtonClick,
                    ),
                  if (state is DamodarAIAnalyzerOnTimedout)
                    AICardWidget(
                      message: "Request timedout! Try again later.",
                      onPressed: _handleGenerateButtonClick,
                    ),
                  WaterECWidget(
                      ec: ecSensor.ec,
                      min: ecMin,
                      max: ecMax,
                      average: ecSensor.ecAvg),
                  GenericLineChart(
                    data: [ecData, ecRawData],
                    title: "EC",
                    yAxisLabel: "EC (μS/cm)",
                    minY: double.parse((0.0).toStringAsFixed(2)),
                    maxY: double.parse((3.0).toStringAsFixed(2)),
                  ),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
