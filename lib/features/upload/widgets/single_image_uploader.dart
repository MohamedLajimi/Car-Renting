import 'package:car_renting/core/utils/snackbar_utils.dart';
import 'package:car_renting/core/widgets/custom_linear_progress_indicator.dart';
import 'package:car_renting/core/widgets/custom_network_image.dart';
import 'package:car_renting/core/widgets/remove_icon_button.dart';
import 'package:car_renting/features/upload/cubit/upload_cubit.dart';
import 'package:car_renting/features/upload/widgets/media_picker_bottom_sheet.dart';
import 'package:car_renting/features/upload/widgets/tap_to_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleImageUploader extends StatelessWidget {
  final Function(String) onSuccess;
  const SingleImageUploader({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadCubit, UploadState>(
      listener: (context, state) {
        if (state is UploadSuccess) {
          onSuccess(state.urls.first);
        }
        if (state is UploadFailure) {
          SnackBarUtils.show(
            context,
            message: state.message,
            type: SnackBarType.error,
            actionLabel: 'Retry',
            onAction: () =>
                context.read<UploadCubit>().uploadFiles(state.files),
          );
        }
      },

      builder: (context, state) => switch (state) {
        UploadInitial() => TapToUploadWidget(
          onTap: () => MediaPickerBottomSheet.show(
            context,
            onImagesSelected: (files) =>
                context.read<UploadCubit>().uploadFiles(files),
          ),
        ),

        UploadLoading() => CustomLinearProgressIndicator(),
        UploadSuccess(:final urls) => Stack(
          children: [
            CustomNetworkImage(imageUrl: urls.first),
            Positioned(
              right: -5,
              top: -5,
              child: RemoveIconButton(
                onRemove: () =>
                    context.read<UploadCubit>().removeImage(urls.first),
              ),
            ),
          ],
        ),
        _ => const SizedBox(),
      },
    );
  }
}
