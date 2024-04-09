import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/features/app/theme/style.dart';

import 'features/app/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        dialogBackgroundColor: appBarColor,
        appBarTheme: AppBarTheme(
          color: appBarColor,
        )
      ),
      home:SplashScreen(),
    );
  }
}

