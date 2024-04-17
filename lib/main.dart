import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_whatsapp/features/app/theme/style.dart';
import 'package:flutter_whatsapp/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter_whatsapp/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:flutter_whatsapp/features/user/presentation/cubit/get_device_number/get_device_number_cubit.dart';
import 'package:flutter_whatsapp/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:flutter_whatsapp/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:flutter_whatsapp/firebase_options.dart';
import 'package:flutter_whatsapp/routes/on_generate_routes.dart';
import 'features/app/splash/splash_screen.dart';

import 'main_injection_container.dart' as di;
import 'main_injection_container.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>di.sl<AuthCubit>()),
        BlocProvider(create: (context)=>di.sl<CredentialCubit>()),
        BlocProvider(create: (context)=>di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (context)=>di.sl<UserCubit>()),
        BlocProvider(create: (context)=>di.sl<GetDeviceNumberCubit>()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}

