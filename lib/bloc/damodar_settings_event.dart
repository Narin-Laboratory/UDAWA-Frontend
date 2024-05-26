part of 'damodar_settings_bloc.dart';

@immutable
sealed class DamodarSettingsEvent {}

final class DamodarSettingsRequest extends DamodarSettingsEvent {
  final dynamic command;

  DamodarSettingsRequest({
    required this.command,
  });
}

final class DamodarSettingsResponse extends DamodarSettingsEvent {
  final DeviceConfig deviceConfig;

  DamodarSettingsResponse({
    required this.deviceConfig,
  });
}

final class DamodarSettingsIdle extends DamodarSettingsEvent {}

final class DamodarSettingsTimedout extends DamodarSettingsEvent {}
