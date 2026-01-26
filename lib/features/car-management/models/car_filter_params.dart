import 'package:car_renting/core/enums/currency_enum.dart';
import 'package:car_renting/core/enums/fuel_type_enum.dart';
import 'package:car_renting/core/enums/transmission_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CarFilterParams extends Equatable {
  final String? searchQuery;
  final String? city;
  final FuelType? fuelType;
  final Transmission? transmission;
  final double? minPrice;
  final double? maxPrice;
  final Currency? currency;

  const CarFilterParams({
    this.searchQuery,
    this.city,
    this.fuelType,
    this.transmission,
    this.minPrice,
    this.maxPrice,
    this.currency,
  });

  CarFilterParams copyWith({
    String? searchQuery,
    String? city,
    FuelType? fuelType,
    Transmission? transmission,
    double? minPrice,
    double? maxPrice,
    Currency? currency,
  }) => CarFilterParams(
    searchQuery: searchQuery ?? this.searchQuery,
    city: city ?? this.city,
    fuelType: fuelType ?? this.fuelType,
    transmission: transmission ?? this.transmission,
    minPrice: minPrice ?? this.minPrice,
    maxPrice: maxPrice ?? this.maxPrice,
    currency: currency ?? this.currency,
  );

  Query applyToQuery(Query baseQuery) {
    Query query = baseQuery;

    if (searchQuery != null && searchQuery!.trim().isNotEmpty) {
      query = query.where(
        'searchKeywords',
        arrayContains: searchQuery!.toLowerCase().trim(),
      );
    }

    if (city != null && city!.trim().isNotEmpty) {
      query = query.where('city', isEqualTo: city!.trim().toLowerCase());
    }

    if (fuelType != null) {
      query = query.where('fuelType', isEqualTo: fuelType!.name);
    }

    if (transmission != null) {
      query = query.where('transmission', isEqualTo: transmission!.name);
    }

    if (minPrice != null) {
      query = query.where('pricePerDay', isGreaterThanOrEqualTo: minPrice);
    }

    if (maxPrice != null) {
      query = query.where('pricePerDay', isLessThanOrEqualTo: maxPrice);
    }

    if (currency != null) {
      query = query.where('currency', isEqualTo: currency!.name);
    }

    return query;
  }

  bool get hasFilters =>
      (searchQuery?.isNotEmpty ?? false) ||
      fuelType != null ||
      transmission != null ||
      minPrice != null ||
      maxPrice != null;

  bool get hasPriceFilter => minPrice != null || maxPrice != null;

  CarFilterParams removeFilter(String filterKey) {
    switch (filterKey) {
      case 'search':
        return copyWith(searchQuery: '');
      case 'city':
        return copyWith(city: null);
      case 'fuelType':
        return copyWith(fuelType: null);
      case 'transmission':
        return copyWith(transmission: null);
      case 'minPrice':
        return copyWith(minPrice: null);
      case 'maxPrice':
        return copyWith(maxPrice: null);
      case 'price':
        return copyWith(minPrice: null, maxPrice: null);
      case 'currency':
        return copyWith(currency: null);
      default:
        return this;
    }
  }

  List<MapEntry<String, String>> getActiveFilters() {
    final filters = <MapEntry<String, String>>[];

    if (searchQuery?.isNotEmpty ?? false) {
      filters.add(MapEntry('search', '"$searchQuery"'));
    }

    if (city != null) {
      filters.add(MapEntry('city', city!));
    }

    if (fuelType != null) {
      filters.add(MapEntry('fuelType', fuelType!.name));
    }

    if (transmission != null) {
      filters.add(MapEntry('transmission', transmission!.name));
    }

    if (hasPriceFilter) {
      final priceLabel = _formatPriceFilter();
      filters.add(MapEntry('price', priceLabel));
    }

    if (currency != null) {
      filters.add(MapEntry('currency', currency!.name));
    }

    return filters;
  }

  String _formatPriceFilter() {
    if (minPrice != null && maxPrice != null) {
      return '\$${minPrice!.toInt()}-\$${maxPrice!.toInt()}';
    } else if (minPrice != null) {
      return '>\$${minPrice!.toInt()}';
    } else {
      return '<\$${maxPrice!.toInt()}';
    }
  }

  @override
  List<Object?> get props => [
    searchQuery,
    city,
    fuelType,
    transmission,
    minPrice,
    maxPrice,
    currency,
  ];
}
