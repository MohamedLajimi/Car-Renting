import 'dart:developer';

import 'package:car_renting/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class UserLocation {
  final double lat;
  final double lng;
  final String address;
  final String city;

  UserLocation({
    required this.lat,
    required this.lng,
    required this.address,
    required this.city,
  });
}

class LocationService {
  Future<Either<Failure, UserLocation>> getCurrentLocation() async {
    try {
      final permissionResult = await _handlePermissions();
      if (permissionResult.isLeft()) {
        return Left(permissionResult.getLeft().toNullable()!);
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      final locationData = await getAddressFromCoords(
        position.latitude,
        position.longitude,
      );

      return Right(
        UserLocation(
          lat: position.latitude,
          lng: position.longitude,
          address: locationData['address']!,
          city: locationData['city']!,
        ),
      );
    } catch (e) {
      return Left(Failure("location.errors.unexpected_error"));
    }
  }

  Future<Either<Failure, UserLocation>> getCoordsFromAddress(
    String address,
  ) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final locationData = await getAddressFromCoords(
          loc.latitude,
          loc.longitude,
        );

        return Right(
          UserLocation(
            lat: loc.latitude,
            lng: loc.longitude,
            address: locationData['address']!,
            city: locationData['city']!,
          ),
        );
      }
      return const Left(Failure("location.errors.coords_not_found"));
    } catch (e) {
      return Left(Failure("location.errors.search_failed"));
    }
  }

  Future<Either<Failure, bool>> _handlePermissions() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    log(permission.name);

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const Left(Failure('location.errors.permission_denied'));
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return const Left(
        Failure('location.errors.permission_permanently_denied'),
      );
    }

    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const Left(Failure('location.errors.location_disabled_error'));
    }

    return const Right(true);
  }

  Future<Map<String, String>> getAddressFromCoords(
    double lat,
    double lng,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];

        final city =
            place.locality ??
            place.subAdministrativeArea ??
            place.administrativeArea ??
            "location.errors.unknown_city";

        final parts = [
          place.street,
          place.subLocality,
          place.locality,
          place.postalCode,
        ].where((part) => part != null && part.isNotEmpty).toList();

        final address = parts.isNotEmpty
            ? parts.join(', ')
            : "location.errors.unknown_address";

        return {'address': address, 'city': city};
      }

      return {
        'address': "location.errors.unknown_address",
        'city': "location.errors.unknown_city",
      };
    } catch (_) {
      return {
        'address': "location.errors.address_not_found",
        'city': "location.errors.unknown_city",
      };
    }
  }
}
