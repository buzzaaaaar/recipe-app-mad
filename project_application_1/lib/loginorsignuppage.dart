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
          const SizedBox(height: 50), // Space between image and buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                // Login Button
                InkWell(
                  onTap: () {
                    // Handle Login button press
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDB4F), // Button color #ffdb4f
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                    ),
                    height: 60, // Height of the button
                    width: double.infinity, // Full width
                    alignment: Alignment.center, // Center the text
                    child: const Text(
                      'LOG IN',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 24, // Font size
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Space between buttons

                // Sign Up Button
                InkWell(
                  onTap: () {
                    // Handle Signup button press
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDB4F), // Button color #ffdb4f
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                    ),
                    height: 60, // Height of the button
                    width: double.infinity, // Full width
                    alignment: Alignment.center, // Center the text
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 24, // Font size
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 