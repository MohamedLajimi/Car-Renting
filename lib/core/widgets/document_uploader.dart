import 'package:car_renting/core/di/injection_container.dart';
import 'package:car_renting/core/enums/car_document_enum.dart';
import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/services/upload_service.dart';
import 'package:car_renting/core/utils/snackbar_utils.dart';
import 'package:car_renting/core/widgets/custom_image_wrapper.dart';
import 'package:car_renting/core/widgets/custom_linear_progress_indicator.dart';
import 'package:car_renting/features/upload/cubit/upload_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentUploader extends StatelessWidget {
  final CarDocumentType type;
  final List<String> currentUrls;
  final Function(List<String>) onUrlsChanged;

  const DocumentUploader({
    super.key,
    required this.type,
    required this.currentUrls,
    required this.onUrlsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UploadCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(type.icon, size: 20, color: context.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                type.displayName,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                final uploadservice = serviceLocator<UploadService>();
                final files = await uploadservice.pickMultipleImages();
                if (files != null) {
                  cubit.uploadFiles(files);
                }
              },
              icon: Icon(
                CupertinoIcons.add_circled,
                color: context.colorScheme.primary,
              ),
            ),
          ],
        ),

        Text(type.hint, style: context.textTheme.bodySmall),

        const SizedBox(height: 12),
        BlocConsumer<UploadCubit, UploadState>(
          listener: (context, state) {
            if (state is UploadSuccess) {
              final updatedUrls = [...currentUrls, ...state.urls];
              onUrlsChanged(updatedUrls);
            }
            if (state is UploadFailure) {
              SnackBarUtils.show(
                context,
                message: context.tr(state.message),
                type: SnackBarType.error,
              );
            }
          },
          builder: (context, state) {
            if (state is UploadLoading) {
              return const CustomLinearProgressIndicator();
            }
            if (currentUrls.isEmpty) {
              return const SizedBox();
            }
            return SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => CustomImageWrapper(
                  url: currentUrls[index],
                  height: 100,
                  width: context.screenWidth * 0.3,
                  onDelete: () {
                    final updated = currentUrls
                        .where((u) => u != currentUrls[index])
                        .toList();
                    onUrlsChanged(updated);
                  },
                ),
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemCount: currentUrls.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
