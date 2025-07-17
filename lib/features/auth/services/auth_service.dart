import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone({
    required String phone,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(FirebaseAuthException) onFailed,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (credential) async => await _auth.signInWithCredential(credential),
        verificationFailed: onFailed,
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      if (e is FirebaseAuthException) onFailed(e);
      rethrow;
    }
  }

  Future<UserCredential> signInWithOtp(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw FirebaseAuthException(code: 'invalid-otp', message: 'Invalid or expired OTP.');
    }
  }

  User? get currentUser => _auth.currentUser;

  Future<void> signOut() async => await _auth.signOut();
}