import 'package:car_renting/features/car-management/models/car_model.dart';
import 'package:equatable/equatable.dart';

class CarParams extends Equatable {
  final String? id;
  final String brand;
  final String model;
  final FuelType fuelType;
  final Transmission transmission;
  final double pricePerDay;
  final int seats;
  final List<CarFeature> features;
  final String address;
  final double lat;
  final double lng;
  final List<String> images;
  final List<DateTime> busyDays;

  const CarParams({
    this.id,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.transmission,
    required this.pricePerDay,
    required this.seats,
    required this.features,
    required this.address,
    required this.lat,
    required this.lng,
    required this.images,
    this.busyDays = const [],
  });

  Map<String, dynamic> toMap(String ownerId) {
    return {
      'ownerId': ownerId,
      'brand': brand,
      'model': model,
      'fuelType': fuelType.name,
      'transmission': transmission.name,
      'pricePerDay': pricePerDay,
      'seats': seats,
      'features': features.map((e) => e.name).toList(),
      'address': address,
      'lat': lat,
      'lng': lng,
      'images': images,
      'rate': 0.0,
      'busyDays': busyDays.map((date) => date.toIso8601String()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, brand, model, pricePerDay];
}
