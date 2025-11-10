import 'package:flutter/material.dart';

import 'package:flutter_notesapplication/login.dart';

void main() {
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: LoginScreen()
    );
  }
}

