import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseService _authService = FirebaseService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  User? get currentUser => _authService.currentUser;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Stream for auth state changes
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    clearError();
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getFriendlyErrorMessage(e));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred.');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String fullName, String email, String password) async {
    _setLoading(true);
    clearError();
    try {
      await _authService.registerWithEmailAndPassword(email, password);
      await _authService.updateDisplayName(fullName);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getFriendlyErrorMessage(e));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred.');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    clearError();
    try {
      await _authService.sendPasswordResetEmail(email);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getFriendlyErrorMessage(e));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred.');
      _setLoading(false);
      return false;
    }
  }

  String _getFriendlyErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
