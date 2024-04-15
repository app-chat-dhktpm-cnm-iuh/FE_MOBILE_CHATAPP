import 'package:firebase_auth/firebase_auth.dart';

class OTPService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static String verifyId = '';

  static Future sentOTP(
      {required String phone,
      required Function errorStep,
      required Function nextStep}) async {
    await _firebaseAuth
        .verifyPhoneNumber(
          timeout: const Duration(seconds: 45),
          phoneNumber: phone,
          verificationCompleted: (phoneAuthCredential) async { 
            return;
          },
          verificationFailed: (error) async {
            return;
          },
          codeSent: (verificationId, forceResendingToken) async {
            verifyId = verificationId;
            nextStep();
          },
          codeAutoRetrievalTimeout: (verificationId) {
            return;
          },
        )
        .onError((error, stackTrace) => {errorStep(), print(stackTrace.toString())});
  }

  static Future verifyOTP({required String otp}) async {
    final cred = PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

    try {
      final user = await _firebaseAuth.signInWithCredential(cred);
      if(user.user!=null) {
        return "Success";
      } else return "Mã xác thực không đúng";
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }
}
