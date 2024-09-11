import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  // Fetch user role from Firestore based on their email
  Future<String?> getUserRole(String email) async {
    try {

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {

        return snapshot.docs.first['role'];
      } else {
        throw Exception('User not found in Firestore.');
      }
    } catch (e) {
      throw Exception('Failed to fetch user role: $e');
    }
  }


  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reauthenticateWithCredential(EmailAuthProvider.credential(
          email: user.email!, password: currentPassword));
      await user.updatePassword(newPassword);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
