import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add logo image here
            Image.asset(
              'assets/images.jpg', // Replace with your logo's path
              height: 100, // Adjust the height as needed
            ),
            const SizedBox(height: 20),
            const TextField(
                decoration: InputDecoration(labelText: 'Nama Lengkap')),
            const TextField(decoration: InputDecoration(labelText: 'Email')),
            const TextField(
                decoration: InputDecoration(labelText: 'Nomor Telepon')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update profil
              },
              child: const Text('Ubah Profil'),
            ),
          ],
        ),
      ),
    );
  }
}
