import 'dart:io';

import 'package:car_renting/core/di/injection_container.dart';
import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/services/upload_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class MediaPickerBottomSheet extends StatelessWidget {
  final Function(List<File>) onImagesSelected;

  const MediaPickerBottomSheet({super.key, required this.onImagesSelected});

  static Future<void> show(
    BuildContext context, {
    required Function(List<File>) onImagesSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) =>
          MediaPickerBottomSheet(onImagesSelected: onImagesSelected),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final uploadService = serviceLocator<UploadService>();
    final image = await uploadService.pickImage(source);

    if (image != null && context.mounted) {
      context.pop();
      onImagesSelected([image]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const .only(top: 24, bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withAlpha(100),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: Icon(CupertinoIcons.camera),
            title: Text(context.tr('media.upload.from_camera')),
            onTap: () => _pickImage(context, ImageSource.camera),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.photo),
            title: Text(context.tr('media.upload.from_gallery')),
            onTap: () => _pickImage(context, ImageSource.gallery),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
