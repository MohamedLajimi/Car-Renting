part of 'upload_cubit.dart';

abstract class UploadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadInitial extends UploadState {}

class UploadLoading extends UploadState {}

class UploadSuccess extends UploadState {
  final List<String> urls;
  UploadSuccess(this.urls);

  UploadSuccess copyWith({List<String>? urls}) =>
      UploadSuccess(urls ?? this.urls);

  @override
  List<Object?> get props => [urls];
}

class UploadFailure extends UploadState {
  final String message;
  final List<File> files;
  UploadFailure({required this.message, required this.files});

  @override
  List<Object?> get props => [message, files];
}
