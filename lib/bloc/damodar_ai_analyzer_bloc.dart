// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udawa/data/data_provider/websocket_data_provider.dart';
import 'package:udawa/models/ai_analyzer_model.dart';

part 'damodar_ai_analyzer_event.dart';
part 'damodar_ai_analyzer_state.dart';

class DamodarAIAnalyzerBloc
    extends Bloc<DamodarAIAnalyzerEvent, DamodarAIAnalyzerState> {
  BuildContext? _context; // Store the BuildContext

  DamodarAIAnalyzerBloc(BuildContext context)
      : super(DamodarAIAnalyzerInitial()) {
    _context = context;
    on<DamodarAIAnalyzerRequest>(_onDamodarAIAnalyzerRequest);
    on<DamodarAIAnalyzerResponse>(_onDamodarAIAnalyzerResponse);
    on<DamodarAIAnalyzerIdle>(_onDamodarAIAnalyzerIdle);
    on<DamodarAIAnalyzerTimedout>(_onDamodarAIAnalyzerTimedout);
  }

  void _onDamodarAIAnalyzerRequest(
      DamodarAIAnalyzerRequest event, Emitter<DamodarAIAnalyzerState> emit) {
    emit(DamodarAIAnalyzerOnRequest(command: event.command));
    final webSocketService = _context!.read<WebSocketService>();
    webSocketService.send(event.command);
  }

  void _onDamodarAIAnalyzerResponse(
      DamodarAIAnalyzerResponse event, Emitter<DamodarAIAnalyzerState> emit) {
    emit(DamodarAIAnalyzerOnResponse(
        damodarAIAnalyzer: event.damodarAIAnalyzer));
  }

  void _onDamodarAIAnalyzerIdle(
      DamodarAIAnalyzerIdle event, Emitter<DamodarAIAnalyzerState> emit) {
    emit(DamodarAIAnalyzerOnIdle());
  }

  void _onDamodarAIAnalyzerTimedout(
      DamodarAIAnalyzerTimedout event, Emitter<DamodarAIAnalyzerState> emit) {
    emit(DamodarAIAnalyzerOnTimedout());
  }
}
