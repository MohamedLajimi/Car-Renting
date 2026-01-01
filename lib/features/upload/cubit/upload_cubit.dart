import 'dart:io';

import 'package:car_renting/core/error/failure.dart';
import 'package:car_renting/features/upload/repositories/i_upload_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

part 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  final IUploadRepository _repository;
  UploadCubit({required IUploadRepository repository})
    : _repository = repository,
      super(UploadInitial());

  Future<void> uploadFiles(List<File> files, {bool isVideo = false}) async {
    emit(UploadLoading());

    final List<Future<Either<Failure, String>>> uploadTasks = files.map((file) {
      return _repository.uploadMedia(file: file, isVideo: isVideo);
    }).toList();

    final List<Either<Failure, String>> results = await Future.wait(
      uploadTasks,
    );

    final List<String> uploadedUrls = [];
    String? errorMessage;

    for (final result in results) {
      result.fold(
        (failure) => errorMessage = failure.message,
        (url) => uploadedUrls.add(url),
      );
    }

    if (errorMessage != null) {
      emit(UploadFailure(message: errorMessage!, files: files));
    } else {
      emit(UploadSuccess(uploadedUrls));
    }
  }

  void removeImage(String url) {
    if (state is UploadSuccess) {
      final currentState = state as UploadSuccess;
      if (currentState.urls.length > 1) {
        final updatedUrls = currentState.urls.where((e) => e != url).toList();
        emit(currentState.copyWith(urls: updatedUrls));
      } else {
        emit(UploadInitial());
      }
    } else {
      emit(UploadInitial());
    }
  }
}
