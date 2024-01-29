import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controllers/auth_controller.dart';

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade900),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}

class MyCupertinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: const AuthGate(),
      // Define other CupertinoApp properties as needed
    );
  }
}
