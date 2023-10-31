import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'home_gadadar.dart';
import 'login.dart';
import 'websocket.dart';

class UdawaApp extends StatelessWidget {
  final wsService = WebSocketService();

  UdawaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UDAWA',
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) =>
            LoginPage(wsService: wsService), // removed const
        '/home-gadadar': (BuildContext context) =>
            HomePageGadadar(wsService: wsService), // removed const
      },
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
    );
  }
}
