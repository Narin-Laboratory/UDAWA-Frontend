// ignore: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:udawa/models/ai_analyzer_model.dart';
import 'package:udawa/models/device_attributes_model.dart';
import 'package:udawa/models/device_config_model.dart';
import 'package:udawa/models/device_telemetry_model.dart';
import 'package:udawa/models/green_house_parameters.dart';
import 'package:udawa/models/power_sensor_model.dart';
import 'package:udawa/models/ec_sensor_model.dart';
import 'package:udawa/models/temperature_sensor_model.dart';

part 'websocket_event.dart';
part 'websocket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  WebSocketBloc() : super(WebSocketInitial()) {
    on<WebSocketOnMessage>(_onWebSocketOnMessage);
    on<WebSocketOnError>(_onWebSocketOnError);
    on<WebSocketOnDisconnect>(_onWebSocketOnDisconnect);
  }

  void _onWebSocketOnDisconnect(
      WebSocketOnDisconnect event, Emitter<WebSocketState> emit) {
    emit(WebSocketDisconnect());
  }

  void _onWebSocketOnError(
      WebSocketOnError event, Emitter<WebSocketState> emit) {
    emit(WebSocketError(error: event.error));
  }

  void _onWebSocketOnMessage(
      WebSocketOnMessage event, Emitter<WebSocketState> emit) {
    try {
      print(event.message);
      // Handle message if not null
      if (event.message != null) {
        if (event.message?['status'] != null) {
          final code = event.message?['status']?['code'] ?? -1;
          if (code == 200) {
            emit(WebSocketLocalAuthReceived(model: event.message));
          } else if (code != 200) {
            emit(WebSocketLocalAuthError(message: event.message));
          }
        } else if (event.message?['attr'] != null) {
          final DeviceAttributes attributes =
              DeviceAttributes.fromJson(event.message['attr']);
          emit(WebSocketMessageReadyDeviceAttributes(attributes: attributes));
        } else if (event.message?['devTel'] != null) {
          final DeviceTelemetry telemetry =
              DeviceTelemetry.fromJson(event.message['devTel']);
          emit(WebSocketMessageReadyDeviceTelemetry(telemetry: telemetry));
        } else if (event.message?['cfg'] != null) {
          final DeviceConfig config =
              DeviceConfig.fromJson(event.message['cfg']);
          emit(WebSocketMessageReadyDeviceConfig(config: config));
        } else if (event.message?['temperature'] != null) {
          final TemperatureSensor temperatureSensor =
              TemperatureSensor.fromJson(event.message['temperature']);
          emit(WebSocketMessageReadyTemperatureSensor(
              temperatureSensor: temperatureSensor));
        } else if (event.message?['ec'] != null) {
          final ECSensor ecSensor = ECSensor.fromJson(event.message['ec']);
          emit(WebSocketMessageReadyECSensor(ecSensor: ecSensor));
        } else if (event.message?['power'] != null) {
          final PowerSensor powerSensor =
              PowerSensor.fromJson(event.message['power']);
          emit(WebSocketMessageReadyPowerSensor(powerSensor: powerSensor));
        } else if (event.message?['getGHParams'] != null) {
          final GreenHouseParameters ghParams =
              GreenHouseParameters.fromJson(event.message["getGHParams"]);
          print(event.message);
          emit(WebSocketMessageReadyGHParams(ghParams: ghParams));
        } else if (event.message?['damodarAIAnalyzer'] != null) {
          final DamodarAIAnalyzer damodarAIAnalyzer =
              DamodarAIAnalyzer.fromJson(event.message["damodarAIAnalyzer"]);
          //print(test);
          emit(WebSocketMessageReadyDamodarAIAnalyzer(
              damodarAIAnalyzer: damodarAIAnalyzer));
        }
      }

      //emit(WebSocketMessageReady(message: event.message));
    } catch (e) {
      //print("__func__ ${e}");
    }
  }
}
