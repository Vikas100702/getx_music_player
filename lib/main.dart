import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:getx_music_player/view/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TuneHub',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0
        ),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

