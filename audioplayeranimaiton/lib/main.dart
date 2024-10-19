import 'package:audioplayeranimaiton/screen/base_anmiation_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BassAnimationApp());
}

class BassAnimationApp extends StatelessWidget {
  const BassAnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bass Animation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Gilroy'),
      home: const BassAnimationScreen(),
    );
  }
}
