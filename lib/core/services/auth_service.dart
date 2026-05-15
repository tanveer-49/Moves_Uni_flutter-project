import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signup({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'role': 'user',
      });

      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      print("LOGIN UID: $uid");

      final doc =
      await _firestore.collection('users').doc(uid).get();

      // CHECK IF DOCUMENT EXISTS
      if (!doc.exists) {
        return 'User data not found in Firestore';
      }

      final data = doc.data();

      // CHECK ROLE FIELD
      if (data == null || !data.containsKey('role')) {
        return 'Role field missing';
      }

      return data['role'];

    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}