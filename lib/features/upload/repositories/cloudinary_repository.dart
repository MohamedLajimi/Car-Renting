import 'dart:io';

import 'package:car_renting/env_config.dart';
import 'package:car_renting/core/error/failure.dart';
import 'package:car_renting/features/upload/repositories/i_upload_repository.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';

class CloudinaryRepository implements IUploadRepository {
  final Dio _dio;
  
  final String _cloudName = EnvConfig.cloudinaryCloudName;
  final String _uploadPreset = EnvConfig.cloudinaryUploadPreset;

  CloudinaryRepository(this._dio);

  @override
  Future<Either<Failure, String>> uploadMedia({
    required File file,
    bool isVideo = false,
  }) async {
    return _handleUpload(() async {
      final String resourceType = isVideo ? 'video' : 'image';
      final String url = "https://api.cloudinary.com/v1_1/$_cloudName/$resourceType/upload";

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'upload_preset': _uploadPreset,
      });

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      return response.data['secure_url'] as String;
    });
  }

  Future<Either<Failure, T>> _handleUpload<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on DioException catch (e) {
      return Left(Failure(_mapDioError(e)));
    } catch (e) {
      return Left(Failure('media.errors.unexpected'.tr()));
    }
  }

  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'media.errors.connection_timeout'.tr();
      case DioExceptionType.sendTimeout:
        return 'media.errors.send_timeout'.tr();
      default:
        return 'media.errors.generic_server_error'.tr();
    }
  }
}