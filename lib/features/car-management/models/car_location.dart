import 'package:equatable/equatable.dart';

class CarLocation extends Equatable {
  final double lat;
  final double lng;
  final String address;
  final String city;

  const CarLocation({
    required this.lat,
    required this.lng,
    required this.address,
    required this.city,
  });

  CarLocation copyWith({
    double? lat,
    double? lng,
    String? address,
    String? city,
  }) => CarLocation(
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    address: address ?? this.address,
    city: city ?? this.city,
  );

  Map<String, dynamic> toMap() => {
    'lat': lat,
    'lng': lng,
    'address': address,
    'city': city,
  };

  factory CarLocation.fromMap(Map<String, dynamic> map) => CarLocation(
    lat: (map['lat'] ?? 0.0).toDouble(),
    lng: (map['lng'] ?? 0.0).toDouble(),
    address: map['address'] ?? '',
    city: map['city'] ?? '',
  );

  @override
  List<Object?> get props => [lat, lng, address, city];
}
