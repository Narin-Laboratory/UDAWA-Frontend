// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udawa/data/data_provider/websocket_data_provider.dart';
import 'package:udawa/models/device_config_model.dart';

part 'damodar_settings_event.dart';
part 'damodar_settings_state.dart';

class DamodarSettingsBloc
    extends Bloc<DamodarSettingsEvent, DamodarSettingsState> {
  BuildContext? _context; // Store the BuildContext

  DamodarSettingsBloc(BuildContext context) : super(DamodarSettingsInitial()) {
    _context = context;
    on<DamodarSettingsRequest>(_onDamodarSettingsRequest);
    on<DamodarSettingsResponse>(_onDamodarSettingsResponse);
    on<DamodarSettingsIdle>(_onDamodarSettingsIdle);
    on<DamodarSettingsTimedout>(_onDamodarSettingsTimedout);
  }

  void _onDamodarSettingsRequest(
      DamodarSettingsRequest event, Emitter<DamodarSettingsState> emit) {
    emit(DamodarSettingsOnRequest(command: event.command));
    final webSocketService = _context!.read<WebSocketService>();
    webSocketService.send(event.command);
  }

  void _onDamodarSettingsResponse(
      DamodarSettingsResponse event, Emitter<DamodarSettingsState> emit) {
    emit(DamodarSettingsOnResponse(deviceConfig: event.deviceConfig));
  }

  void _onDamodarSettingsIdle(
      DamodarSettingsIdle event, Emitter<DamodarSettingsState> emit) {
    emit(DamodarSettingsOnIdle());
  }

  void _onDamodarSettingsTimedout(
      DamodarSettingsTimedout event, Emitter<DamodarSettingsState> emit) {
    emit(DamodarSettingsOnTimedout());
  }
}
