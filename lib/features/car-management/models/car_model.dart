import 'package:equatable/equatable.dart';
import 'package:easy_localization/easy_localization.dart';

enum FuelType {
  petrol,
  diesel,
  electric,
  hybrid;

  String get displayName => 'fuel_type.$name'.tr();
}

enum Transmission {
  manual,
  automatic;

  String get displayName => 'transmission.$name'.tr();
}

enum CarFeature {
  ac,
  bluetooth,
  infotainment,
  gps,
  backupCamera,
  sunroof,
  cruiseControl,
  typeC,
  heatedSeats,
  keyless;

  String get displayName => 'car_features.$name'.tr();
}

class CarModel extends Equatable {
  final String id;
  final String ownerId;
  final String brand;
  final String model;
  final FuelType fuelType;
  final Transmission transmission;
  final double pricePerDay;
  final List<String> images;
  final int seats;
  final List<CarFeature> features;
  final String address;
  final double lat;
  final double lng;
  final List<DateTime> busyDays;
  final double rate;

  const CarModel({
    required this.id,
    required this.ownerId,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.transmission,
    required this.pricePerDay,
    required this.images,
    required this.seats,
    required this.features,
    required this.address,
    required this.lat,
    required this.lng,
    required this.busyDays,
    required this.rate,
  });

  factory CarModel.fromMap(Map<String, dynamic> map, String docId) {
    return CarModel(
      id: docId,
      ownerId: map['ownerId'] ?? '',
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      fuelType: FuelType.values.byName(map['fuelType'] ?? 'petrol'),
      transmission: Transmission.values.byName(map['transmission'] ?? 'manual'),
      pricePerDay: (map['pricePerDay'] ?? 0).toDouble(),
      images: List<String>.from(map['images'] ?? []),
      seats: map['seats']?.toInt() ?? 4,
      features: (map['features'] as List? ?? [])
          .map((e) => CarFeature.values.byName(e.toString()))
          .toList(),
      address: map['address'] ?? '',
      lat: (map['lat'] ?? 0.0).toDouble(),
      lng: (map['lng'] ?? 0.0).toDouble(),
      busyDays: (map['busyDays'] as List? ?? [])
          .map((e) => DateTime.parse(e))
          .toList(),
      rate: (map['rate'] ?? 0.0).toDouble(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'brand': brand,
      'model': model,
      'fuelType': fuelType.name,
      'transmission': transmission.name,
      'pricePerDay': pricePerDay,
      'images': images,
      'seats': seats,
      'features': features.map((e) => e.name).toList(),
      'address': address,
      'lat': lat,
      'lng': lng,
      'busyDays': busyDays.map((e) => e.toIso8601String()).toList(),
      'rate': rate,
    };
  }

  @override
  List<Object?> get props => [id, ownerId, brand, model];
}
