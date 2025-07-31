import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Registro con email y contraseña
  Future<User?> registerUser({
    required String email,
    required String password,
    required String name,
    required int age,
  }) async {
    try {
      // 1. Registrar en Firebase Auth
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authResult.user == null) return null;

      // 2. Guardar datos adicionales en Realtime Database
      await _database.child('users').child(authResult.user!.uid).set({
        'name': name,
        'age': age,
        'email': email,
        'createdAt': ServerValue.timestamp,  // Timestamp especial de Firebase
      });

      return authResult.user;
    } catch (e) {
      debugPrint("Error en registro: $e");
      return null;
    }
  }
  // Inicio de sesión con email y contraseña
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      debugPrint("Error en login: $e");
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }
}