import 'package:car_renting/core/enums/currency_enum.dart';
import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class PriceInputWithCurrency extends StatelessWidget {
  final double initialPrice;
  final Currency selectedCurrency;
  final Function(double) onPriceChanged;
  final Function(Currency) onCurrencyChanged;

  const PriceInputWithCurrency({
    super.key,
    required this.initialPrice,
    required this.selectedCurrency,
    required this.onPriceChanged,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialPrice > 0 ? initialPrice.toString() : null,
      keyboardType: TextInputType.number,
      onChanged: (val) => onPriceChanged(double.tryParse(val) ?? 0),
      decoration: InputDecoration(
        hintText: "0.00",
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Currency>(
              value: selectedCurrency,
              icon: const Icon(Icons.keyboard_arrow_down, size: 18),
              onChanged: (Currency? newValue) {
                if (newValue != null) onCurrencyChanged(newValue);
              },
              items: Currency.values.map((Currency c) {
                return DropdownMenuItem<Currency>(
                  value: c,
                  child: Text(
                    c.displayName,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
