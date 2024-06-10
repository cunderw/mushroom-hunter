import 'package:flutter/material.dart';

import 'controllers/auth_controller.dart';

class MyMushroomHunterApp extends StatelessWidget {
  const MyMushroomHunterApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color.fromRGBO(2, 84, 34, 0.329),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Color.fromRGBO(2, 84, 34, 0.329),
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
