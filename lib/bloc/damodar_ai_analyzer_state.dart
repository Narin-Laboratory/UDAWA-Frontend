part of 'damodar_ai_analyzer_bloc.dart';

@immutable
sealed class DamodarAIAnalyzerState {}

final class DamodarAIAnalyzerInitial extends DamodarAIAnalyzerState {}

final class DamodarAIAnalyzerOnRequest extends DamodarAIAnalyzerState {
  final dynamic command;
  DamodarAIAnalyzerOnRequest({
    required this.command,
  });
}

final class DamodarAIAnalyzerOnResponse extends DamodarAIAnalyzerState {
  final DamodarAIAnalyzer damodarAIAnalyzer;

  DamodarAIAnalyzerOnResponse({
    required this.damodarAIAnalyzer,
  });
}

final class DamodarAIAnalyzerOnIdle extends DamodarAIAnalyzerState {}

final class DamodarAIAnalyzerOnTimedout extends DamodarAIAnalyzerState {}
