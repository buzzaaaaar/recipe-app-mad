import 'package:flutter/material.dart';
import 'loginpage.dart';  
import 'signuppage.dart';  

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginOrSignupPage(),
    );
  }
}

class LoginOrSignupPage extends StatefulWidget {
  const LoginOrSignupPage({super.key});

  @override
  LoginOrSignupPageState createState() => LoginOrSignupPageState();
}

class LoginOrSignupPageState extends State<LoginOrSignupPage> {
  bool isLoginPressed = false;
  bool isSignUpPressed = false;

  void _setButtonState(bool isPressed, bool isLogin) {
    setState(() {
      if (isLogin) {
        isLoginPressed = isPressed;
      } else {
        isSignUpPressed = isPressed;
      }
    });

    if (isPressed) {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          if (isLogin) {
            isLoginPressed = false;
          } else {
            isSignUpPressed = false;
          }
        });
      });
      if (isLogin) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF8210), // Background color #ff8210
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Image.asset('assets/Logo.png', width: 400, height: 400),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                CustomButton(
                  text: 'LOG IN',
                  isPressed: isLoginPressed,
                  onPressState: (isPressed) => _setButtonState(isPressed, true),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'SIGN UP',
                  isPressed: isSignUpPressed,
                  onPressState: (isPressed) => _setButtonState(isPressed, false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final bool isPressed;
  final Function(bool) onPressState;

  const CustomButton({
    super.key,
    required this.text,
    required this.isPressed,
    required this.onPressState,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onPressState(true),
      onTapUp: (_) => onPressState(false),
      onTapCancel: () => onPressState(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 60,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPressed ? const Color(0xFFFF8210) : const Color(0xFFFFDB4F),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isPressed ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
