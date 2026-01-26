import 'package:car_renting/core/di/injection_container.dart';
import 'package:car_renting/core/enums/car_document_enum.dart';
import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/widgets/custom_button.dart';
import 'package:car_renting/core/widgets/document_uploader.dart';
import 'package:car_renting/features/car-management/blocs/car_form_cubit/car_form_cubit.dart';
import 'package:car_renting/features/car-management/blocs/car_management_bloc/car_management_bloc.dart';
import 'package:car_renting/features/car-management/models/car_document.dart';
import 'package:car_renting/features/car-management/models/car_params.dart';
import 'package:car_renting/features/upload/cubit/upload_cubit.dart';
import 'package:car_renting/features/upload/widgets/car_form_image_grid_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarFormMediaAndDocumentsSection extends StatelessWidget {
  final CarFormState state;
  final Function(CarParams) onSubmit;
  const CarFormMediaAndDocumentsSection({
    super.key,
    required this.state,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CarFormCubit>();
    final urls = state.params.images;
    final bool isLimitReached = urls.length >= 10;
    final Color statusColor = urls.length < 3
        ? Colors.orange
        : (isLimitReached ? Colors.red : Colors.greenAccent);
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('car_management.media.limit_info'),
                style: context.textTheme.bodySmall,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${urls.length}/10",
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          BlocProvider(
            create: (context) => serviceLocator<UploadCubit>(),
            child: CarFormImageGridView(
              currentUrls: urls,
              onUrlsChanged: (images) => cubit.updateImages(images),
            ),
          ),
          ..._buildDocsUploaders(context, state.params.documents),
          const SizedBox(height: 24),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () => cubit.setSection(1),
                  text: context.tr('car_management.buttons.back'),
                  backgroundColor: context.colorScheme.onSurfaceVariant,
                ),
              ),
              Expanded(
                child:
                    BlocSelector<CarManagementBloc, CarManagementState, bool>(
                      selector: (state) {
                        return state is CarManagementActionState &&
                            (state.type == ActionType.create ||
                                state.type == ActionType.update) &&
                            state.isLoading;
                      },
                      builder: (context, isLoading) {
                        return CustomButton(
                          isEnabled: state.canSubmit,
                          isLoading: isLoading,
                          text: context.tr('car_management.buttons.submit'),
                          onPressed: () => onSubmit(state.params),
                        );
                      },
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDocsUploaders(
    BuildContext context,
    List<CarDocument> docs,
  ) {
    final cubit = context.read<CarFormCubit>();

    return CarDocumentType.values.map((type) {
      final existingDoc = docs.cast<CarDocument?>().firstWhere(
        (e) => e?.type == type,
        orElse: () => null,
      );

      final currentUrls = existingDoc?.urls ?? [];

      return BlocProvider(
        key: ValueKey(type),
        create: (context) => serviceLocator<UploadCubit>(),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: DocumentUploader(
            type: type,
            currentUrls: currentUrls,
            onUrlsChanged: (newUrls) {
              cubit.updateDocument(type, newUrls);
            },
          ),
        ),
      );
    }).toList();
  }
}
