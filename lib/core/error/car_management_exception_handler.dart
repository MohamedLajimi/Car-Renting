import 'dart:developer';

import 'package:car_renting/core/error/failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarExceptionHandler {
  static Failure handleException(dynamic e) {
    log('CarManagement Error: ${e.toString()}');

    if (e is FirebaseException) {
      switch (e.code) {
        case 'permission-denied':
          return Failure('car.error.permission_denied');
        case 'not-found':
          return Failure('car.error.not_found');
        case 'unavailable':
          return Failure('car.error.network');
        case 'quota-exceeded':
          return Failure('car.error.storage_full');
        default:
          return Failure('car.error.database_error');
      }
    }

    return Failure('car.error.unknown');
  }
}
