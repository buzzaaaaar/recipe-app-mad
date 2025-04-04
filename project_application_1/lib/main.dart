import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'loginorsignuppage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Add the navigation after 5 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginOrSignupPage()),
      );
    });

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
              backgroundColor:
                  Colors.transparent, // Set the background color to transparent
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFFFFDB4F),
              ), // Progress bar color
              minHeight: 10, // Height of the progress bar
            ),
          ),
        ],
      ),
    );
  }
}
