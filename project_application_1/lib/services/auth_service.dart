import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart'; // Import your UserModel

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Verify Auth is initialized
      if (_auth.app == null) {
        throw Exception("Firebase Auth not initialized");
      }
      // Create user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create a user document in Firestore
      if (userCredential.user != null) {
        UserModel newUser = UserModel(
          id: userCredential.user!.uid,
          username: username,
          email: email,
          createdAt: DateTime.now().toIso8601String(),
        );

        // Add user to Firestore
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(newUser.toJson());
      }

      return userCredential;
    } catch (e) {
      print("Auth Error: $e");
      rethrow; // Rethrow to handle in UI
    }
  }

  // Login with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Error in signInWithEmailAndPassword: $e");
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
