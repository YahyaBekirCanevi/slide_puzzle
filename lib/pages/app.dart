import 'package:flutter/material.dart';
import 'package:slide_puzzle/pages/main_screen/main_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF666666),
        backgroundColor: const Color(0xFFDDDDBB),
      ),
      themeMode: ThemeMode.light,
      home: const MainScreen(),
    );
  }
}
