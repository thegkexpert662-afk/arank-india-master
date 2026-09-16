import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MasterAuthService {
  MasterAuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<String?> signInAsMaster({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = credential.user?.uid;
      if (uid == null) return 'Unable to identify the signed-in account.';

      final snapshot = await _firestore
          .collection('master_admins')
          .doc(uid)
          .get();

      if (!snapshot.exists) {
        await _auth.signOut();
        return 'This account is not authorized as Master Admin.';
      }

      final data = snapshot.data() ?? <String, dynamic>{};
      if (data['role'] != 'master_admin' || data['isActive'] != true) {
        await _auth.signOut();
        return 'Master Admin access is disabled or invalid.';
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return _authMessage(e.code);
    } catch (_) {
      return 'Sign in failed. Please try again.';
    }
  }

  Future<void> signOut() => _auth.signOut();

  String _authMessage(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'invalid-login-credentials':
      case 'wrong-password':
      case 'user-not-found':
        return 'Email or password is incorrect.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Unable to sign in. Please check your connection and try again.';
    }
  }
}
