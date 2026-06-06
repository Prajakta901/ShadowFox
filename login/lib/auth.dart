import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/main.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<AppUser?> signIn(String email, String password) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user != null) {
      return AppUser(
        uid: credential.user!.uid,
        email: credential.user!.email ?? email,
      );
    } 
    else {
      return null;
    }
  }

  // Backward-compatible alias
  Future<AppUser?> smthng(String email, String password) async {
    return signIn(email, password);
  }

  Future<AppUser?> signUp(String email, String password) async {
    final UserCredential credential = await _auth
                   .createUserWithEmailAndPassword(email: email, password: password);
    if (credential.user != null) {
      return AppUser(uid: credential.user!.uid, email: credential.user!.email!);
    } else {
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
