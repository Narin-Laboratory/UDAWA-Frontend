part of 'damodar_settings_bloc.dart';

@immutable
sealed class DamodarSettingsState {}

final class DamodarSettingsInitial extends DamodarSettingsState {}

final class DamodarSettingsOnRequest extends DamodarSettingsState {
  final dynamic command;
  DamodarSettingsOnRequest({
    required this.command,
  });
}

final class DamodarSettingsOnResponse extends DamodarSettingsState {
  final DeviceConfig deviceConfig;

  DamodarSettingsOnResponse({
    required this.deviceConfig,
  });
}

final class DamodarSettingsOnIdle extends DamodarSettingsState {}

final class DamodarSettingsOnTimedout extends DamodarSettingsState {}
