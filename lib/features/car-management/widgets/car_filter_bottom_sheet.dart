import 'package:car_renting/core/enums/currency_enum.dart';
import 'package:car_renting/core/enums/fuel_type_enum.dart';
import 'package:car_renting/core/enums/transmission_enum.dart';
import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/widgets/custom_button.dart';
import 'package:car_renting/core/widgets/custom_selection_grid.dart';
import 'package:car_renting/core/widgets/custom_text_form_field.dart';
import 'package:car_renting/features/car-management/models/car_filter_params.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CarFilterBottomSheet extends StatefulWidget {
  final CarFilterParams currentFilters;

  const CarFilterBottomSheet({super.key, required this.currentFilters});

  @override
  State<CarFilterBottomSheet> createState() => _CarFilterBottomSheetState();

  static Future<CarFilterParams?> show(
    BuildContext context, {
    required CarFilterParams currentFilters,
  }) {
    return showModalBottomSheet<CarFilterParams>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) =>
          CarFilterBottomSheet(currentFilters: currentFilters),
    );
  }
}

class _CarFilterBottomSheetState extends State<CarFilterBottomSheet> {
  late final TextEditingController _cityController;
  late final ValueNotifier<bool> _hasChangesNotifier;
  late final ValueNotifier<bool> _hasFiltersNotifier;

  late FuelType? _selectedFuelType;
  late Transmission? _selectedTransmission;
  late RangeValues _priceRange;
  late Currency _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController(text: widget.currentFilters.city);
    _selectedFuelType = widget.currentFilters.fuelType;
    _selectedTransmission = widget.currentFilters.transmission;
    _selectedCurrency = widget.currentFilters.currency ?? Currency.tnd;
    _priceRange = RangeValues(
      widget.currentFilters.minPrice ?? 0,
      widget.currentFilters.maxPrice ?? 500,
    );

    _hasChangesNotifier = ValueNotifier(false);
    _hasFiltersNotifier = ValueNotifier(_checkHasFilters());
    _cityController.addListener(_onFiltersChanged);
  }

  @override
  void dispose() {
    _cityController.dispose();
    _hasChangesNotifier.dispose();
    _hasFiltersNotifier.dispose();
    super.dispose();
  }

  bool _checkHasChanges() {
    final cityChanged =
        _cityController.text.trim() != (widget.currentFilters.city ?? '');
    final fuelChanged = _selectedFuelType != widget.currentFilters.fuelType;
    final transmissionChanged =
        _selectedTransmission != widget.currentFilters.transmission;
    final minPriceChanged =
        (_priceRange.start > 0 ? _priceRange.start : null) !=
        widget.currentFilters.minPrice;
    final maxPriceChanged =
        (_priceRange.end < 500 ? _priceRange.end : null) !=
        widget.currentFilters.maxPrice;
    final currencyChanged =
        _selectedCurrency != (widget.currentFilters.currency ?? Currency.tnd);

    return cityChanged ||
        fuelChanged ||
        transmissionChanged ||
        minPriceChanged ||
        maxPriceChanged ||
        currencyChanged;
  }

  bool _checkHasFilters() {
    return _cityController.text.trim().isNotEmpty ||
        _selectedFuelType != null ||
        _selectedTransmission != null ||
        _priceRange.start > 0 ||
        _priceRange.end < 500;
  }

  void _onFiltersChanged() {
    _hasChangesNotifier.value = _checkHasChanges();
    _hasFiltersNotifier.value = _checkHasFilters();
  }

  void _reset() {
    setState(() {
      _selectedFuelType = null;
      _selectedTransmission = null;
      _selectedCurrency = Currency.tnd;
      _cityController.clear();
      _priceRange = const RangeValues(0, 500);
    });
    _onFiltersChanged();
  }

  void _apply() {
    final cityText = _cityController.text.trim();
    final filters = CarFilterParams(
      searchQuery: widget.currentFilters.searchQuery,
      city: cityText.isNotEmpty ? cityText : null,
      fuelType: _selectedFuelType,
      transmission: _selectedTransmission,
      minPrice: _priceRange.start > 0 ? _priceRange.start : null,
      maxPrice: _priceRange.end < 500 ? _priceRange.end : null,
      currency: _selectedCurrency,
    );
    context.pop(filters);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,

      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 16),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: context.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.4,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    context.tr('car_management.filters.title'),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => context.pop(null),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('car_management.filters.city'),
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        prefixIcon: Icons.location_on_outlined,
                        hintText: 'eg. Paris',
                        controller: _cityController,
                      ),
                      const SizedBox(height: 16),
                      CustomSelectionGrid<FuelType?>(
                        title: context.tr(
                          'car_management.filters.fuel_type_title',
                        ),
                        items: [null, ...FuelType.values],
                        selectedItem: _selectedFuelType,
                        labelBuilder: (item) =>
                            item?.displayName ??
                            context.tr('car_management.filters.any'),
                        iconBuilder: (item) => item?.icon,
                        onSelected: (item) {
                          setState(() => _selectedFuelType = item);
                          _onFiltersChanged();
                        },
                        crossAxisCount: 2,
                      ),
                      CustomSelectionGrid<Transmission?>(
                        title: context.tr(
                          'car_management.filters.transmission_title',
                        ),
                        items: [null, ...Transmission.values],
                        selectedItem: _selectedTransmission,
                        labelBuilder: (item) =>
                            item?.displayName ??
                            context.tr('car_management.filters.any'),
                        iconBuilder: (item) => item?.icon,
                        onSelected: (item) {
                          setState(() => _selectedTransmission = item);
                          _onFiltersChanged();
                        },
                        crossAxisCount: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.tr(
                              'car_management.filters.price_range_title',
                            ),
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<Currency>(
                              value: _selectedCurrency,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                              ),
                              onChanged: (Currency? newValue) {
                                if (newValue != null) {
                                  setState(() => _selectedCurrency = newValue);
                                  _onFiltersChanged();
                                }
                              },
                              items: Currency.values.map((Currency c) {
                                return DropdownMenuItem<Currency>(
                                  value: c,
                                  child: Text(
                                    c.displayName,
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: context.colorScheme.onSurface,
                                        ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_priceRange.start.toInt()}',
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_priceRange.end.toInt()}',
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 500,
                        divisions: 50,
                        onChanged: (values) {
                          setState(() => _priceRange = values);
                          _onFiltersChanged();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _hasFiltersNotifier,
                        builder: (context, hasFilters, _) {
                          return CustomButton(
                            text: context.tr('car_management.filters.reset'),
                            onPressed: _reset,
                            backgroundColor:
                                context.colorScheme.onSurfaceVariant,
                            isEnabled: hasFilters,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _hasChangesNotifier,
                        builder: (context, hasChanges, _) {
                          return CustomButton(
                            text: context.tr('car_management.filters.apply'),
                            onPressed: _apply,
                            isEnabled: hasChanges,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
