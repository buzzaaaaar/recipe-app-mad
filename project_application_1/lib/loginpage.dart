import 'package:flutter/material.dart';
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
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isButtonPressed = false;
  bool _isSignUpLinkPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Images
          Positioned(
            top: -80,
            left: -80,
            child: Image.asset('assets/topshape.png', width: 300),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Image.asset('assets/bottomshape.png', width: 300),
          ),

          // Login Box
          Center(
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Welcome back!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Log in to continue",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),

                    // Username Field
                    _buildTextField(
                      controller: _usernameController,
                      label: "USERNAME",
                      maxLength: 20,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Password Field
                    _buildTextField(
                      controller: _passwordController,
                      label: "PASSWORD",
                      isPassword: true,
                      maxLength: 20,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isButtonPressed = true;
                          });
                          // Simulate a login action (e.g., navigate to another page)
                          Future.delayed(const Duration(seconds: 1), () {
                            // Add navigation code here (e.g., Navigator.push)
                            setState(() {
                              _isButtonPressed =
                                  false; // Reset button state after action
                            });
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isButtonPressed
                                ? Colors.white
                                : const Color(0xFFFFDB4F),
                        side: BorderSide(
                          color: const Color(0xFFFFDB4F),
                          width: 2,
                        ),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _isButtonPressed ? "Logging In..." : "LOG IN",
                        style: TextStyle(
                          color:
                              _isButtonPressed
                                  ? const Color(0xFFFFDB4F)
                                  : Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Sign-up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account? "),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSignUpLinkPressed = true;
                            });
                            // Simulate navigation to sign-up page
                            Future.delayed(const Duration(milliseconds: 200), () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                              setState(() {
                                _isSignUpLinkPressed =
                                    false; // Reset link state after action
                              });
                            });
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color:
                                  _isSignUpLinkPressed
                                      ? Colors.blue
                                      : Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              decoration:
                                  _isSignUpLinkPressed
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Input Field Widget
  static Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFFDB4F),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          maxLength: maxLength,
          validator: validator,
          decoration: InputDecoration(
            counterText: '', // Hide the character count
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFFDB4F)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFFDB4F)),
            ),
          ),
        ),
      ],
    );
  }
}
