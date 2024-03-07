import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:udawa/app_bloc_observer.dart';
import 'package:udawa/bloc/auth_bloc.dart';
import 'package:udawa/bloc/websocket_bloc.dart';
import 'package:udawa/data/data_provider/websocket_data_provider.dart';
import 'package:udawa/localization/locales.dart';
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
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    configureLocalization();
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
      ],
      child: MaterialApp(
        title: 'UDAWA Smart System',
        theme: ThemeData.dark(
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        supportedLocales: localization.supportedLocales,
        localizationsDelegates: localization.localizationsDelegates,
        home: const LoginScreen(),
      ),
    );
  }

  void configureLocalization() {
    localization.init(mapLocales: LOCALES, initLanguageCode: "id");
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }
}
