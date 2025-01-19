import 'package:flutter/material.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a GlobalKey to manage the form's state
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Lupa Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey, // Attach the form key
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo image
              Image.asset(
                'assets/images.jpg', // Replace with your logo's path
                height: 100, // Adjust the height as needed
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Masukkan Email'),
                // Add email validation
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  // Check if the email is valid
                  final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegExp.hasMatch(value)) {
                    return 'Format email salah';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Validate the form
                  if (formKey.currentState!.validate()) {
                    // If the form is valid, navigate to the LoginPage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  }
                },
                child: const Text('Kirim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
