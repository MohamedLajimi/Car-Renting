import 'package:car_renting/core/enums/car_feature_enum.dart';
import 'package:car_renting/core/enums/fuel_type_enum.dart';
import 'package:car_renting/core/enums/transmission_enum.dart';
import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/utils/debouncer.dart';
import 'package:car_renting/core/widgets/custom_button.dart';
import 'package:car_renting/core/widgets/custom_counter.dart';
import 'package:car_renting/core/widgets/custom_multi_chip_selector.dart';
import 'package:car_renting/core/widgets/custom_selection_grid.dart';
import 'package:car_renting/core/widgets/custom_text_form_field.dart';
import 'package:car_renting/core/widgets/price_input_with_currency.dart';
import 'package:car_renting/features/car-management/blocs/car_form_cubit/car_form_cubit.dart';
import 'package:car_renting/features/car-management/widgets/car_status_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarFormBasicSection extends StatefulWidget {
  final CarFormState state;
  const CarFormBasicSection({super.key, required this.state});

  @override
  State<CarFormBasicSection> createState() => _CarFormBasicSectionState();
}

class _CarFormBasicSectionState extends State<CarFormBasicSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _yearController;

  late final Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.state.params.brand);
    _modelController = TextEditingController(text: widget.state.params.model);
    _yearController = TextEditingController(
      text: widget.state.params.year.toString(),
    );

    _debouncer = Debouncer(milliseconds: 300);
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onBrandChanged() {
    _debouncer.run(() {
      context.read<CarFormCubit>().updateBrand(_brandController.text);
    });
  }

  void _onModelChanged() {
    _debouncer.run(() {
      context.read<CarFormCubit>().updateModel(_modelController.text);
    });
  }

  void _onPriceChanged(double price) {
    _debouncer.run(() {
      context.read<CarFormCubit>().updatePricePerDay(price);
    });
  }

  void _onYearChanged() {
    _debouncer.run(() {
      final year = int.tryParse(_yearController.text) ?? 2020;
      context.read<CarFormCubit>().updateYear(year);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CarFormCubit>();
    final params = widget.state.params;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (params.id != null)
              CarStatusManager(
                status: params.status,
                onToggleVisibility: () => cubit.toggleVisibility(),
              ),
            const SizedBox(height: 16),
            _buildLabel(context, 'car_management.fields.brand'),
            CustomTextFormField(
              hintText: context.tr('car_management.placeholders.brand'),
              controller: _brandController,
              prefixIcon: CupertinoIcons.tag,
              onChanged: (value) => _onBrandChanged(),
            ),
            const SizedBox(height: 16),

            _buildLabel(context, 'car_management.fields.model'),
            CustomTextFormField(
              hintText: context.tr('car_management.placeholders.model'),
              controller: _modelController,
              prefixIcon: CupertinoIcons.square_stack_3d_up,
              onChanged: (value) => _onModelChanged(),
            ),
            const SizedBox(height: 16),

            _buildLabel(context, 'car_management.fields.year'),
            CustomTextFormField(
              hintText: 'eg. 2020',
              controller: _yearController,
              prefixIcon: CupertinoIcons.calendar,
              onChanged: (value) => _onYearChanged(),
            ),
            const SizedBox(height: 16),

            _buildLabel(context, 'car_management.fields.price'),
            PriceInputWithCurrency(
              initialPrice: params.pricePerDay,
              selectedCurrency: params.currency,
              onPriceChanged: (value) => _onPriceChanged(value),
              onCurrencyChanged: (currency) => cubit.updateCurrency(currency),
            ),
            const SizedBox(height: 16),

            CustomSelectionGrid<Transmission>(
              title: context.tr('car_management.fields.transmission'),
              items: Transmission.values,
              selectedItem: params.transmission,
              labelBuilder: (item) => item.displayName,
              iconBuilder: (item) => item.icon,
              onSelected: (val) => cubit.updateTransmission(val),
            ),
            const SizedBox(height: 16),

            CustomSelectionGrid<FuelType>(
              title: context.tr('car_management.fields.fuel_type'),
              items: FuelType.values,
              selectedItem: params.fuelType,
              labelBuilder: (item) => item.displayName,
              iconBuilder: (item) => item.icon,
              onSelected: (val) => cubit.updateFuelType(val),
            ),
            const SizedBox(height: 16),

            CustomCounter(
              title: context.tr('car_management.fields.seats'),
              value: params.seats,
              onChanged: (value) => cubit.updateSeats(value),
            ),
            const SizedBox(height: 16),

            CustomMultiChipSelector<CarFeature>(
              title: context.tr('car_management.fields.features'),
              items: CarFeature.values,
              selectedItems: params.features,
              labelBuilder: (f) => f.displayName,
              iconBuilder: (f) => f.icon,
              onToggle: (f) => cubit.updateFeatures(f),
            ),

            const SizedBox(height: 36),

            CustomButton(
              text: context.tr('car_management.buttons.next'),
              onPressed: () {
                if (widget.state.nextEnabled) {
                  cubit.setSection(1);
                }
              },
              isEnabled: widget.state.nextEnabled,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        context.tr(key),
        style: context.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
