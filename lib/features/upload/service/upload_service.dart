import 'dart:io';

import 'package:image_picker/image_picker.dart';

class UploadService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    final XFile? selectedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    return selectedFile != null ? File(selectedFile.path) : null;
  }

    Future<File?> pickVideo(ImageSource source) async {
    final XFile? selectedFile = await _picker.pickVideo(
      source: source,
      maxDuration: Duration(seconds: 30)
    );
    return selectedFile != null ? File(selectedFile.path) : null;
  }
}