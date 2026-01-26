import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/widgets/availability_picker.dart';
import 'package:car_renting/core/widgets/custom_button.dart';
import 'package:car_renting/core/widgets/location_picker.dart';
import 'package:car_renting/features/car-management/blocs/car_form_cubit/car_form_cubit.dart';
import 'package:car_renting/features/car-management/models/car_location.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarFormLocationAndAvailabilitySection extends StatelessWidget {
  final CarFormState state;
  const CarFormLocationAndAvailabilitySection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CarFormCubit>();
    final params = state.params;
    return SingleChildScrollView(
      child: Column(
        spacing: 24,
        children: [
          LocationPicker(
            currentAddress: params.location.address,
            lat: params.location.lat,
            lng: params.location.lng,
            onLocationChanged: (address, city, lat, lng) =>
                cubit.updateLocation(
                  CarLocation(lat: lat, lng: lng, address: address, city: city),
                ),
          ),
          AvailabilityPicker(
            blockedDays: state.params.blockedDays,
            bookedDays: state.params.bookedDays,
            onBlockedDaysChanged: (dates) => cubit.updateBlockedDays(dates),
          ),

          Row(
            spacing: 8,
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () => cubit.setSection(0),
                  text: context.tr('car_management.buttons.back'),
                  backgroundColor: context.colorScheme.onSurfaceVariant,
                ),
              ),
              Expanded(
                child: CustomButton(
                  isEnabled: state.nextEnabled,
                  text: context.tr('car_management.buttons.next'),
                  onPressed: () => cubit.setSection(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
