import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'car_model.dart';

class CarFilterParams extends Equatable {
  final String? searchQuery;
  final FuelType? fuelType;
  final Transmission? transmission;
  final double? minPrice;
  final double? maxPrice;

  const CarFilterParams({
    this.searchQuery,
    this.fuelType,
    this.transmission,
    this.minPrice,
    this.maxPrice,
  });

  Query applyToQuery(Query baseQuery) {
    Query query = baseQuery;

    if (searchQuery != null && searchQuery!.trim().isNotEmpty) {
      query = query.where('searchKeywords', arrayContains: searchQuery!.toLowerCase().trim());
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

    return query;
  }

  bool get hasFilters =>
      (searchQuery?.isNotEmpty ?? false) ||
      fuelType != null ||
      transmission != null ||
      minPrice != null ||
      maxPrice != null;

  bool get hasPriceFilter => minPrice != null || maxPrice != null;

  @override
  List<Object?> get props => [
        searchQuery,
        fuelType,
        transmission,
        minPrice,
        maxPrice,
      ];
}