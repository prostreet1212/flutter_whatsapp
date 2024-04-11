import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/features/app/theme/style.dart';
import 'package:flutter_whatsapp/routes/on_generate_routes.dart';

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
        useMaterial3: false,
        scaffoldBackgroundColor: backgroundColor,
        dialogBackgroundColor: appBarColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        )
      ),
      //home:const SplashScreen(),
      initialRoute: '/',
      onGenerateRoute: OnGenerateRoute.route,
      routes: {
    '/':(context)=>SplashScreen()
      },
    );
  }
}

