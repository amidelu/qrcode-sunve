import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'screens/screens.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const InstallScreen(),
    );
  }
}
