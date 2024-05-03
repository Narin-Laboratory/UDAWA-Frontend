part of 'damodar_ai_analyzer_bloc.dart';

@immutable
sealed class DamodarAIAnalyzerEvent {}

final class DamodarAIAnalyzerRequest extends DamodarAIAnalyzerEvent {
  final dynamic command;

  DamodarAIAnalyzerRequest({
    required this.command,
  });
}

final class DamodarAIAnalyzerResponse extends DamodarAIAnalyzerEvent {
  final DamodarAIAnalyzer damodarAIAnalyzer;

  DamodarAIAnalyzerResponse({
    required this.damodarAIAnalyzer,
  });
}

final class DamodarAIAnalyzerIdle extends DamodarAIAnalyzerEvent {}

final class DamodarAIAnalyzerTimedout extends DamodarAIAnalyzerEvent {}
