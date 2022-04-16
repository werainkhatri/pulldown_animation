import 'package:flutter/material.dart';
import 'constants.dart';
import 'screens/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(backgroundColor: Constants.backgroundColor),
      home: const HomeScreen(),
    );
  }
}
