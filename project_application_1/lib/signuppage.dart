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
      home: const SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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

          // Sign-Up Box
          Center(
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
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
                      "SIGN UP",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Updated Color
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Create your account",
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
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Email Address Field
                    _buildTextField(
                      controller: _emailController,
                      label: "EMAIL ADDRESS",
                      maxLength: 40,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email address';
                        }
                        if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                            .hasMatch(value)) {
                          return 'Enter a valid email';
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
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Confirm Password Field
                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: "CONFIRM PASSWORD",
                      isPassword: true,
                      maxLength: 20,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Sign Up Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isButtonPressed = true;
                          });
                          // Simulate a sign-up action (e.g., navigate to another page)
                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              _isButtonPressed = false; // Reset button state
                            });
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isButtonPressed ? Colors.white : const Color(0xFF0EDDD2),
                        side: const BorderSide(color: Color(0xFF0EDDD2), width: 2),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _isButtonPressed ? "Signing Up..." : "SIGN UP",
                        style: TextStyle(
                          color: _isButtonPressed ? const Color(0xFF0EDDD2) : Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSignUpLinkPressed = true;
                            });
                            // Simulate navigation to sign-up page
                            Future.delayed(const Duration(seconds: 1), () {
                              // Add navigation code here (e.g., Navigator.push)
                              setState(() {
                                _isSignUpLinkPressed = false; // Reset link state after action
                              });
                            });
                          },
                          child: Text(
                            "Log in",
                            style: TextStyle(
                              color: _isSignUpLinkPressed ? Colors.yellow : Colors.yellow,
                              fontWeight: FontWeight.bold,
                              decoration: _isSignUpLinkPressed ? TextDecoration.underline : TextDecoration.none,
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
            color: Color(0xFF0EDDD2), // Updated Color
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
              borderSide: const BorderSide(color: Color(0xFF0EDDD2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0EDDD2)),
            ),
          ),
        ),
      ],
    );
  }
}