import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // تسجيل مستخدم جديد
  Future<User?> signUp(String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return result.user;
  }

  // تسجيل دخول
  Future<User?> signIn(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return result.user;
  }

  // تسجيل خروج
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // متابعة حالة المستخدم (هل هو مسجل دخول أم لا)
  Stream<User?> get user => _auth.authStateChanges();
}