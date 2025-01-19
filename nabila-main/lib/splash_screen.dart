import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace the Icon with your logo
            Image.asset(
              'assets/images.jpg', // Replace with your logo's path
              height: 100, // Adjust the height as needed
            ),
            const SizedBox(height: 20),
            const Text(
              'Resep Makanan',
              style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 197, 124, 6)),
            ),
            const SizedBox(height: 10),
            const Text(
              'Made by Nabila',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
