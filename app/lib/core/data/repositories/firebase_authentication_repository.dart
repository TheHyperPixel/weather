// import 'dart:async';
// import 'package:app/core/domain/repositories/iauthentication_repository.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:app/core/domain/entities/user_auth/user_auth.dart';
// import 'package:app/core/domain/exceptions/credential_already_linked_exception.dart';
// import 'package:app/core/domain/exceptions/incorrect_password_exception.dart';
// import 'package:app/core/domain/exceptions/invalid_credential_exception.dart';
// import 'package:app/core/domain/exceptions/invalid_email_exception.dart';
// import 'package:app/core/domain/exceptions/invalid_phone_number_exception.dart';
// import 'package:app/core/domain/exceptions/invalid_sms_code_exception.dart';
// import 'package:app/core/domain/exceptions/too_many_requests_exception.dart';
// import 'package:app/core/domain/exceptions/unknown_authentication_exception.dart';
// import 'package:app/core/domain/exceptions/user_already_exists_exception%20copy.dart';
// import 'package:app/core/domain/exceptions/user_disabled_exception%20copy.dart';
// import 'package:app/core/domain/exceptions/user_not_found_exception%20copy.dart';
// import 'package:app/core/domain/exceptions/user_not_verified_exception%20copy.dart';
// import 'package:app/core/domain/exceptions/weak_password_exception%20copy.dart';
// import 'package:injectable/injectable.dart';

// @Injectable(as: IAuthenticationRepository)
// class FirebaseAuthenticationRepository implements IAuthenticationRepository {
//   final FirebaseAuth _firebaseAuth;

//   FirebaseAuthenticationRepository(this._firebaseAuth);

//   @override
//   Future<UserAuth> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       var authResult = await this
//           ._firebaseAuth
//           .signInWithEmailAndPassword(email: email, password: password);

//       if (!(authResult.user!.emailVerified ||
//           authResult.user!.phoneNumber != null)) {
//         throw UserNotVerifiedException();
//       }

//       return UserAuth(
//         uuid: authResult.user!.uid,
//         email: authResult.user!.email ?? '',
//         telephone: authResult.user!.phoneNumber ?? '',
//       );
//     } on FirebaseAuthException catch (e) {
//       throw this._mapFirebaseAuthExceptionToDomainException(e);
//     } on UserNotVerifiedException {
//       rethrow;
//     } catch (e) {
//       throw UnknownAuthenticationException(e);
//     }
//   }

//   @override
//   Future<UserAuth?> get currentUser async {
//     try {
//       User? user = this._firebaseAuth.currentUser;

//       if (user == null) return null;

//       await user.reload();

//       if (!(user.emailVerified || user.phoneNumber != null)) {
//         throw UserNotVerifiedException();
//       }

//       return UserAuth(
//         uuid: user.uid,
//         email: user.email ?? '',
//         telephone: user.phoneNumber ?? '',
//       );
//     } on FirebaseAuthException catch (e) {
//       throw this._mapFirebaseAuthExceptionToDomainException(e);
//     } on UserNotVerifiedException {
//       rethrow;
//     } catch (e) {
//       throw UnknownAuthenticationException(e);
//     }
//   }

//   @override
//   Future<void> logout() async {
//     return await this._firebaseAuth.signOut();
//   }

//   @override
//   Future<UserAuth> signUp({
//     required String? email,
//     required String password,
//   }) async {
//     try {
//       final authResult = await this
//           ._firebaseAuth
//           .createUserWithEmailAndPassword(email: email!, password: password);

//       await authResult.user!.sendEmailVerification();

//       return UserAuth(
//         uuid: authResult.user!.uid,
//         email: authResult.user!.email ?? '',
//         telephone: authResult.user!.phoneNumber ?? '',
//       );
//     } on FirebaseAuthException catch (e) {
//       throw this._mapFirebaseAuthExceptionToDomainException(e);
//     } catch (e) {
//       throw UnknownAuthenticationException(e);
//     }
//   }

//   @override
//   Future<void> sendVerificationEmail() async {
//     try {
//       final currentUser = this._firebaseAuth.currentUser;
//       await currentUser?.sendEmailVerification();
//     } on FirebaseAuthException catch (e) {
//       throw this._mapFirebaseAuthExceptionToDomainException(e);
//     } catch (e) {
//       throw UnknownAuthenticationException(e);
//     }
//   }

//   @override
//   Future<String> sendVerificationSms({
//     required String phoneNumber,
//   }) async {
//     final completer = Completer<String>();

//     await this._firebaseAuth.verifyPhoneNumber(
//           phoneNumber: phoneNumber,
//           verificationCompleted: (_) {
//             print(_);
//           },
//           verificationFailed: (exception) {
//             completer.completeError(
//               this._mapFirebaseAuthExceptionToDomainException(exception),
//             );
//           },
//           codeSent: (verificationId, forceResendingToken) {
//             completer.complete(verificationId);
//           },
//           codeAutoRetrievalTimeout: (_) {},
//           timeout: Duration.zero,
//         );

//     return completer.future;
//   }

//   @override
//   Future<UserAuth> loginWithPhoneNumber({
//     required String verificationId,
//     required String smsCode,
//   }) async {
//     try {
//       final phoneAuthCredential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: smsCode,
//       );

//       final authResult =
//           await this._firebaseAuth.signInWithCredential(phoneAuthCredential);

//       if (!(authResult.user!.emailVerified ||
//           authResult.user!.phoneNumber != null)) {
//         throw UserNotVerifiedException();
//       }

//       return UserAuth(
//         uuid: authResult.user!.uid,
//         email: authResult.user!.email ?? '',
//         telephone: authResult.user!.phoneNumber ?? '',
//       );
//     } on FirebaseAuthException catch (e) {
//       throw this._mapFirebaseAuthExceptionToDomainException(e);
//     } on UserNotVerifiedException {
//       rethrow;
//     } catch (e) {
//       throw UnknownAuthenticationException(e);
//     }
//   }

//   @override
//   Future<void> linkWithCredential({
//     String? email,
//     String? password,
//     String? verificationId,
//     String? smsCode,
//   }) async {
//     late AuthCredential credential;

//     if (email != null && password != null) {
//       credential = EmailAuthProvider.credential(
//         email: email,
//         password: password,
//       );
//     } else if (verificationId != null && smsCode != null) {
//       credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: smsCode,
//       );
//     }

//     try {
//       await this._firebaseAuth.currentUser!.linkWithCredential(credential);
//     } on FirebaseAuthException catch (e) {
//       throw this._mapFirebaseAuthExceptionToDomainException(e);
//     } catch (e) {
//       throw UnknownAuthenticationException(e);
//     }
//   }

//   @override
//   Future<void> reauthenticateWithCredential({
//     String? email,
//     String? password,
//     String? verificationId,
//     String? smsCode,
//   }) async {
//     late AuthCredential credential;

//     if (email != null && password != null) {
//       credential = EmailAuthProvider.credential(
//         email: email,
//         password: password,
//       );
//     } else if (verificationId != null && smsCode != null) {
//       credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: smsCode,
//       );
//     }

//     try {
//       await this
//           ._firebaseAuth
//           .currentUser!
//           .reauthenticateWithCredential(credential);
//     } on FirebaseAuthException catch (e) {
//       throw this._mapFirebaseAuthExceptionToDomainException(e);
//     } catch (e) {
//       throw UnknownAuthenticationException(e);
//     }
//   }

//   @override
//   Future<void> resetPassword({required String email}) async {
//     try {
//       return await this._firebaseAuth.sendPasswordResetEmail(email: email);
//     } on FirebaseAuthException catch (e) {
//       throw this._mapFirebaseAuthExceptionToDomainException(e);
//     } catch (e) {
//       throw UnknownAuthenticationException(e);
//     }
//   }

//   @override
//   Future<void> changePassword({required String password}) async {
//     final user = this._firebaseAuth.currentUser!;

//     try {
//       await user.updatePassword(password);
//     } on FirebaseAuthException catch (e) {
//       throw this._mapFirebaseAuthExceptionToDomainException(e);
//     } catch (e) {
//       throw UnknownAuthenticationException(e);
//     }
//   }

//   @override
//   Future<void> changeEmail({required String email}) async {
//     final user = this._firebaseAuth.currentUser!;

//     try {
//       await user.updateEmail(email);
//     } on FirebaseAuthException catch (e) {
//       throw this._mapFirebaseAuthExceptionToDomainException(e);
//     } catch (e) {
//       throw UnknownAuthenticationException(e);
//     }
//   }

//   @override
//   Future<void> deleteUser() async {
//     final user = this._firebaseAuth.currentUser!;

//     await user.reload();

//     await user.delete();
//   }

//   Exception _mapFirebaseAuthExceptionToDomainException(
//       FirebaseAuthException exception) {
//     switch (exception.code) {
//       case 'user-mismatch':
//       case 'invalid-credential':
//         return InvalidCredentialException();
//       case 'invalid-email':
//         return InvalidEmailException();
//       case 'invalid-phone-number':
//         return InvalidPhoneNumberException();
//       case 'email-already-in-use':
//       case 'credential-already-in-use':
//       case 'account-exists-with-different-credential':
//         return UserAlreadyExistsException();
//       case 'wrong-password':
//         return IncorrectPasswordException();
//       case 'weak-password':
//         return WeakPasswordException();
//       case 'user-disabled':
//         return UserDisabledException();
//       case 'user-not-found':
//         return UserNotFoundException();
//       case 'provider-already-linked':
//         return CredentialAlreadyLinkedException();
//       case 'invalid-verification-code':
//       case 'invalid-verification-id':
//         return InvalidSmsCodeException();
//       case 'too-many-requests':
//         return TooManyRequestsException();
//       case 'requires-recent-login':
//       case 'operation-not-allowed':
//       default:
//         return UnknownAuthenticationException(exception);
//     }
//   }
// }
