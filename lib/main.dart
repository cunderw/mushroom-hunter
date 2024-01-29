import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_mushrooms_hunter/utils/firebase_options.dart';

import 'app.dart';

bool isIOS = Platform.isIOS;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(isIOS ? MyCupertinoApp() : MyMaterialApp());
}
