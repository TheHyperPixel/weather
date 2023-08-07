import 'package:app/core/domain/entities/user_auth/user_auth.dart';

abstract class IAuthenticationRepository {
  Future<UserAuth> login({
    required String email,
    required String password,
  });

  Future<UserAuth?> get currentUser;

  Future<void> logout();

  Future<UserAuth> signUp({
    required String? email,
    required String password,
  });

  Future<void> sendVerificationEmail();

  Future<String> sendVerificationSms({
    required String phoneNumber,
  });

  Future<UserAuth> loginWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  });

  Future<void> linkWithCredential({
    String? email,
    String? password,
    String? verificationId,
    String? smsCode,
  });

  Future<void> reauthenticateWithCredential({
    String? email,
    String? password,
    String? verificationId,
    String? smsCode,
  });

  Future<void> resetPassword({
    required String email,
  });

  Future<void> changePassword({
    required String password,
  });

  Future<void> changeEmail({
    required String email,
  });

  Future<void> deleteUser();
}
