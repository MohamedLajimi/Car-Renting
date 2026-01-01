import 'dart:io';

import 'package:car_renting/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class IUploadRepository {
  Future<Either<Failure, String>> uploadMedia({
    required File file,
    required bool isVideo
  });

}
