import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart';

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
  bool _isLoading = false;

  // Instance of AuthService
  final AuthService _authService = AuthService();

  // Error message to show on UI
  String? _errorMessage;

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
            child: SingleChildScrollView(
              // Added for keyboard adjustment
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
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Create your account",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),

                      // Error message (if any)
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),

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
                          if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                          ).hasMatch(value)) {
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
                        onPressed: _isLoading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isButtonPressed
                                  ? Colors.white
                                  : const Color(0xFF0EDDD2),
                          side: const BorderSide(
                            color: Color(0xFF0EDDD2),
                            width: 2,
                          ),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF0EDDD2),
                                    ),
                                    strokeWidth: 2.0,
                                  ),
                                )
                                : Text(
                                  _isButtonPressed
                                      ? "Signing Up..."
                                      : "SIGN UP",
                                  style: TextStyle(
                                    color:
                                        _isButtonPressed
                                            ? const Color(0xFF0EDDD2)
                                            : Colors.white,
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
                            onTap: _isLoading ? null : _navigateToLogin,
                            child: Text(
                              "Log in",
                              style: TextStyle(
                                color: Colors.yellow,
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
          ),
        ],
      ),
    );
  }

  void _handleSignUp() async {
    // Clear previous error message
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _isButtonPressed = true;
      });

      try {
        // Register the user with Firebase
        await _authService.registerWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          username: _usernameController.text.trim(),
        );

        // If successful, navigate to the home page or login page
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle Firebase Auth specific errors
        String errorMessage;
        print('Firebase Auth Error: ${e.code} - ${e.message}');
        print('Stack trace: ${e.stackTrace}');

        switch (e.code) {
          case 'configuration-not-found':
            errorMessage =
                'Firebase configuration error. Please check your setup.';
            break;
          case 'email-already-in-use':
            errorMessage = 'This email is already registered.';
            break;
          case 'weak-password':
            errorMessage = 'Password is too weak.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address.';
            break;
          default:
            errorMessage = 'Authentication error: ${e.code}';
        }
        setState(() {
          _errorMessage = errorMessage;
        });
      } catch (e) {
        // Handle other errors
        print('General Error: $e');
        
        setState(() {
          _errorMessage = 'Error: $e';
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isButtonPressed = false;
          });
        }
      }
    }
  }

  void _navigateToLogin() {
    setState(() {
      _isSignUpLinkPressed = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        setState(() {
          _isSignUpLinkPressed = false;
        });
      }
    });
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
            color: Color(0xFF0EDDD2),
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
