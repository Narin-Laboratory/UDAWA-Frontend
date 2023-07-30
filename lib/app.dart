import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'home.dart';
import 'login.dart';
import 'model/data_structures.dart';

// TODO: Convert UdawaApp to stateful widget (104)
class UdawaApp extends StatelessWidget {
  const UdawaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UDAWA',
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
        // TODO: Change to a Backdrop with a HomePage frontLayer (104)
        '/': (BuildContext context) => const HomePage(),
        // TODO: Make currentCategory field take _currentCategory (104)
        // TODO: Pass _currentCategory for frontLayer (104)
        // TODO: Change backLayer field value to CategoryMenuPage (104)
      },
      // TODO: Customize the theme (103)
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
    );
  }
}

// TODO: Build a Shrine Theme (103)
// TODO: Build a Shrine Text Theme (103)