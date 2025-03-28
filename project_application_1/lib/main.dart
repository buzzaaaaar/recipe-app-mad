import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF8210), // Background color #ff8210
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20), // Reduced space from top
          Center(
            child: Image.asset(
              'assets/Logo.png', // Ensure this image exists in assets
              width: 400,
              height: 400,
            ),
          ),
          const SizedBox(height: 150), // Space between image and loading bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: LinearProgressIndicator(
              backgroundColor: Colors.transparent, // Set the background color to transparent
              valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFFFDB4F)), // Progress bar color
              minHeight: 10, // Height of the progress bar
            ),
          ),
        ],
      ),
    );
  }
}
