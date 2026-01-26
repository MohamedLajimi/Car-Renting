import 'package:car_renting/core/services/location_service.dart';
import 'package:car_renting/core/utils/snackbar_utils.dart';
import 'package:car_renting/core/widgets/custom_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPicker extends StatefulWidget {
  final String currentAddress;
  final double lat;
  final double lng;
  final Function(String, String, double, double) onLocationChanged;

  const LocationPicker({
    super.key,
    required this.currentAddress,
    required this.lat,
    required this.lng,
    required this.onLocationChanged,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final MapController _mapController = MapController();
  final TextEditingController _addressController = TextEditingController();
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.currentAddress;
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
    _addressController.dispose();
  }

  void _updateFullLocation(String addr, String city, double lat, double lng) {
    setState(() => _addressController.text = addr);
    _mapController.move(LatLng(lat, lng), 15);
    widget.onLocationChanged(addr, city, lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          hintText: context.tr('car_management.fields.address'),
          controller: _addressController,
          prefixIcon: Icons.search,
          suffixIcon: Icons.my_location,
          onTapSuffixIcon: () async {
            final result = await _locationService.getCurrentLocation();
            result.fold(
              (l) => SnackBarUtils.show(
                context,
                message: context.tr(l.message),
                type: SnackBarType.error,
              ),
              (r) => _updateFullLocation(r.address, r.city, r.lat, r.lng),
            );
          },
          onEditingComplete: () async {
            final result = await _locationService.getCoordsFromAddress(
              _addressController.text,
            );
            result.fold(
              (l) => null,
              (r) => _updateFullLocation(r.address, r.city, r.lat, r.lng),
            );
          },
        ),
        const SizedBox(height: 16),

        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 360,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(widget.lat, widget.lng),
                initialZoom: 13,
                onTap: (tapPos, point) async {
                  final data = await _locationService.getAddressFromCoords(
                    point.latitude,
                    point.longitude,
                  );
                  _updateFullLocation(
                    data['address']!,
                    data['city']!,
                    point.latitude,
                    point.longitude,
                  );
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.yourapp.car_renting',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(widget.lat, widget.lng),
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
