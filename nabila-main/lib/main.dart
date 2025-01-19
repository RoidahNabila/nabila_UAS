import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsi App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // Ganti ke SplashScreen
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot_password': (context) => const ForgotPasswordPage(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}