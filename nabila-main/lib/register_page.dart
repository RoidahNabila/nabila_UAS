import 'package:flutter/material.dart';
import 'api_service.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    final ApiService apiService = ApiService();

    void register() async {
      if (formKey.currentState!.validate()) {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        final confirmPassword = confirmPasswordController.text.trim();

        if (password != confirmPassword) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password dan konfirmasi tidak cocok')),
          );
          return;
        }

        final result = await apiService.register(email, password);
        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
          Navigator.pushNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images.jpg',
                height: 100,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegExp.hasMatch(value)) {
                    return 'Format email salah';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: register,
                child: const Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
