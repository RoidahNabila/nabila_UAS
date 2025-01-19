import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import package
import 'api_service.dart'; // Ganti dengan path yang sesuai

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  bool isLoading = false;
  String? errorMessage;

  void login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final email = emailController.text;
    final password = passwordController.text;

    try {
      final response = await apiService.login(email, password);
      if (response['success']) {
        // Simpan access token ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', response['access_token']);

        // Arahkan ke halaman berikutnya
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Tampilkan pesan error dari server
        setState(() {
          errorMessage = response['message'];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal terhubung ke server: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Masuk')),
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
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Color.fromARGB(222, 251, 82, 164)),
                ),
              const SizedBox(height: 10),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: login,
                      child: const Text('Masuk'),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot_password');
                },
                child: const Text('Lupa Password?'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
