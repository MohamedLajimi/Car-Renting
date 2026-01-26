import 'package:car_renting/core/enums/car_feature_enum.dart';
import 'package:car_renting/core/enums/car_status_enum.dart';
import 'package:car_renting/core/enums/currency_enum.dart';
import 'package:car_renting/core/enums/fuel_type_enum.dart';
import 'package:car_renting/core/enums/transmission_enum.dart';
import 'package:car_renting/features/car-management/models/car_document.dart';
import 'package:car_renting/features/car-management/models/car_location.dart';
import 'package:equatable/equatable.dart';

class CarModel extends Equatable {
  final String id;
  final CarStatus status;
  final String ownerId;
  final String brand;
  final String model;
  final int year;
  final FuelType fuelType;
  final Transmission transmission;
  final double pricePerDay;
  final Currency currency;
  final int seats;
  final List<CarFeature> features;
  final CarLocation location;
  final List<DateTime> blockedDays;
  final List<DateTime> bookedDays;
  final List<String> images;
  final List<CarDocument> documents;
  final double rate;

  const CarModel({
    required this.id,
    required this.status,
    required this.ownerId,
    required this.brand,
    required this.model,
    required this.year,
    required this.fuelType,
    required this.transmission,
    required this.pricePerDay,
    required this.currency,
    required this.seats,
    required this.features,
    required this.location,
    required this.blockedDays,
    required this.bookedDays,
    required this.images,
    required this.documents,
    required this.rate,
  });

  factory CarModel.fromMap(Map<String, dynamic> map, String docId) {
    return CarModel(
      id: docId,
      status: CarStatus.fromMap(map['status']),
      ownerId: map['ownerId'] ?? '',
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      fuelType: FuelType.fromMap(map['fuelType']),
      year: map['year']?.toInt() ?? 2020,
      transmission: Transmission.fromMap(map['transmission']),
      pricePerDay: (map['pricePerDay'] ?? 0).toDouble(),
      currency: Currency.fromMap(map['currency']),
      seats: map['seats']?.toInt() ?? 4,
      features: (map['features'] as List? ?? [])
          .map((e) => CarFeature.values.byName(e.toString()))
          .toList(),
      location: CarLocation.fromMap(map['location']),
      blockedDays: (map['blockedDays'] as List? ?? [])
          .map((e) => DateTime.parse(e))
          .toList(),
      bookedDays: (map['bookedDays'] as List? ?? [])
          .map((e) => DateTime.parse(e))
          .toList(),
      images: List<String>.from(map['images'] ?? []),
      documents: (map['documents'] as List? ?? [])
          .map((e) => CarDocument.fromMap(e))
          .toList(),
      rate: (map['rate'] ?? 0.0).toDouble(),
    );
  }
  bool get isAvailable {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    return !bookedDays.any((date) {
          final bookingDate = DateTime(date.year, date.month, date.day);
          return bookingDate == todayDate;
        }) &&
        !blockedDays.any((date) {
          final blockedDate = DateTime(date.year, date.month, date.day);
          return blockedDate == todayDate;
        });
  }

  factory CarModel.dummy() {
    return CarModel(
      id: 'dummy-id',
      status: CarStatus.verified,
      ownerId: 'dummy-owner',
      brand: 'Mercedes',
      model: 'S-Class 2024',
      year: 2024,
      fuelType: FuelType.petrol,
      transmission: Transmission.automatic,
      pricePerDay: 150.0,
      currency: Currency.tnd,
      images: const ['https://via.placeholder.com/400x200.png?text=Car+Image'],
      seats: 5,
      features: const [CarFeature.ac, CarFeature.bluetooth, CarFeature.gps],
      location: CarLocation(
        address: 'Rue de chemin vert 87, Paris',
        city: 'Paris',
        lat: 34.0736,
        lng: -118.4004,
      ),
      blockedDays: const [],
      bookedDays: const [],
      rate: 4.8,
      documents: [],
    );
  }

  static List<CarModel> dummyList(int length) {
    return List.generate(length, (index) => CarModel.dummy());
  }

  @override
  List<Object?> get props => [
    id,
    status,
    ownerId,
    brand,
    model,
    year,
    pricePerDay,
    currency,
    seats,
    features,
    location,
    blockedDays,
    bookedDays,
    images,
    documents,
    rate,
  ];
}
