import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udawa/app_bloc_observer.dart';
import 'package:udawa/bloc/auth_bloc.dart';
import 'package:udawa/bloc/damodar_ai_analyzer_bloc.dart';
import 'package:udawa/bloc/websocket_bloc.dart';
import 'package:udawa/data/data_provider/websocket_data_provider.dart';
import 'package:udawa/models/ai_analyzer_model.dart';
import 'package:udawa/presentation/screens/login_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WebSocketBloc(),
          lazy: true,
        ),
        ChangeNotifierProvider(create: (context) => WebSocketService(context)),
        BlocProvider(
          create: (context) => AuthBloc(context),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => DamodarAIAnalyzerBloc(context),
          lazy: true,
        ),
      ],
      child: MaterialApp(
        title: 'UDAWA Smart System',
        theme: ThemeData.dark(
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
