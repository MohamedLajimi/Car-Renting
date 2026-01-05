import 'dart:developer';

import 'package:car_renting/core/error/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthExceptionHandler {
  static Failure handleException(dynamic e) {
    log(e.toString());
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return Failure('auth.error.email_already_in_use');
        case 'invalid-email':
          return Failure('auth.error.invalid_email');
        case 'weak-password':
          return Failure('auth.error.weak_password');
        case 'user-not-found':
          return Failure('auth.error.user_not_found');
        case 'wrong-password':
          return Failure('auth.error.wrong_password');
        case 'network-request-failed':
          return Failure('auth.error.network');
        case 'too-many-requests':
          return Failure('auth.error.too_many_requests');

        case 'user-disabled':
          return Failure('auth.error.user_disabled');

        case 'invalid-credential':
          return Failure('auth.error.invalid_credential');
        default:
          return Failure('auth.error.unknown');
      }
    }

    if (e is GoogleSignInException) {
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
          return Failure('auth.error.canceled');
        case GoogleSignInExceptionCode.interrupted:
          return Failure('auth.error.interrupted');
        case GoogleSignInExceptionCode.clientConfigurationError:
          return Failure('auth.error.config_error');
        case GoogleSignInExceptionCode.userMismatch:
          return Failure('auth.error.user_mismatch');
        case GoogleSignInExceptionCode.uiUnavailable:
          return Failure('auth.error.ui_unavailable');
        case GoogleSignInExceptionCode.unknownError:
        default:
          return Failure('auth.error.google_unknown');
      }
    }

    if (e is FirebaseException) {
      return Failure('auth.error.db');
    }

    return Failure('auth.error.unknown');
  }
}
