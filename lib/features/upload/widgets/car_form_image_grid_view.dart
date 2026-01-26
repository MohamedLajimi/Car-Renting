import 'package:car_renting/core/di/injection_container.dart';
import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/services/upload_service.dart';
import 'package:car_renting/core/utils/snackbar_utils.dart';
import 'package:car_renting/core/widgets/custom_linear_progress_indicator.dart';
import 'package:car_renting/features/upload/cubit/upload_cubit.dart';
import 'package:car_renting/core/widgets/custom_image_wrapper.dart';
import 'package:car_renting/features/upload/widgets/tap_to_upload_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class CarFormImageGridView extends StatelessWidget {
  final List<String> currentUrls;
  final Function(List<String>) onUrlsChanged;

  const CarFormImageGridView({
    super.key,
    required this.currentUrls,
    required this.onUrlsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final uploadCubit = context.read<UploadCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocConsumer<UploadCubit, UploadState>(
          listener: (context, state) {
            if (state is UploadSuccess) {
              onUrlsChanged([...currentUrls, ...state.urls]);
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
            return Column(
              spacing: 16,
              children: [
                SizedBox(
                  width: context.screenWidth,
                  height: context.screenHeight * 0.2,
                  child: TapToUploadWidget(
                    desc: context.tr('car_management.media.tap_to_upload'),
                    onTap: () async {
                      final uploadservice = serviceLocator<UploadService>();
                      final files = await uploadservice.pickMultipleImages();
                      if (files != null) {
                        uploadCubit.uploadFiles(files);
                      }
                    },
                  ),
                ),
                if (state is UploadLoading)
                  CustomLinearProgressIndicator(height: 12),
              ],
            );
          },
        ),
        const SizedBox(height: 24),

        if (currentUrls.isNotEmpty)
          ReorderableGridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (oldIndex, newIndex) {
              final updatedList = List<String>.from(currentUrls);
              final item = updatedList.removeAt(oldIndex);
              updatedList.insert(newIndex, item);
              onUrlsChanged(updatedList);
            },
            children: List.generate(currentUrls.length, (index) {
              final url = currentUrls[index];
              return CustomImageWrapper(
                key: ValueKey(url),
                height: 120,
                url: url,
                isCover: index == 0,
                onDelete: () {
                  final updatedList = currentUrls
                      .where((e) => e != url)
                      .toList();
                  onUrlsChanged(updatedList);
                },
              );
            }),
          ),
      ],
    );
  }
}
