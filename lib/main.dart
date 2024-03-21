import 'package:alchemy/app_colors.dart';
import 'package:alchemy/home_page.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = true; // Default theme is dark

  void toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alchemy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: isDarkTheme ? AppColors.blackColor : AppColors.whiteColor,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        // ... other non-color theme properties (e.g., textStyle)
      ),
      home: const HomePage(),
    );
  }
}


