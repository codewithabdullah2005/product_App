import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:product_app/screens/auth_screen.dart';
import 'package:product_app/theme/app_colors.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product App',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.green,
          primary: AppColors.green,
          secondary: AppColors.lime,
          surface: AppColors.white,
        ),
        scaffoldBackgroundColor: AppColors.lime,

        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkGreen,
          foregroundColor: AppColors.lime,
          elevation: 0,
        ),

        cardTheme: const CardThemeData(
          color: AppColors.lightGreen,
          elevation: 4,
          margin: EdgeInsets.zero,

        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightGreen,
            foregroundColor: AppColors.white,
          ),
        ),

        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.white,
        ),
      ),

      home: const AuthScreen(),
    );
  }
}
