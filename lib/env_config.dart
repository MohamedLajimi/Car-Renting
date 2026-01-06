import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get cloudinaryCloudName => dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  static String get cloudinaryUploadPreset => dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';
  static String get serverClientId => dotenv.env['SERVER_CLIENT_ID'] ?? '';
}