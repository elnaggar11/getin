import 'package:getincoffee/core/localization/localization_helper.dart';
import 'dart:async';

import 'package:getincoffee/core/services/location_service.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key, this.initialLocation});
  final LatLng? initialLocation;

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(45.521563, -120.677433);
  LatLng? _lastMapPosition;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<GooglePlace> _searchResults = [];
  List<Placemark> _placemarks = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _center = widget.initialLocation!;
    }
    _lastMapPosition = _center;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Future<void> _getCurrentLocation() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _lastMapPosition = LatLng(position.latitude, position.longitude);
    });
    mapController.animateCamera(CameraUpdate.newLatLng(_lastMapPosition!));
  }

  Future<void> _pickLocation() async {
    if (_lastMapPosition != null) {
      _placemarks = await placemarkFromCoordinates(
        _lastMapPosition!.latitude,
        _lastMapPosition!.longitude,
      );
      Navigator.pop(context, [_lastMapPosition, _placemarks]);
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isNotEmpty) {
        setState(() => _isSearching = true);
        try {
          final results = await LocationService.locationFromAddress(query);
          setState(() {
            _searchResults = results;
            _isSearching = false;
          });
        } catch (e) {
          setState(() {
            _searchResults = [];
            _isSearching = false;
          });
        }
      } else {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
    });
  }

  void _selectSearchResult(GooglePlace loc) async {
    final details = await LocationService.getPlaceDetails(loc.placeId);
    if (details == null) return;
    final target = LatLng(details.lat, details.lng);
    final placemarks = await placemarkFromCoordinates(details.lat, details.lng);

    setState(() {
      _lastMapPosition = target;
      _placemarks = placemarks;
      _searchResults = [];
      _searchController.text = details.name;
    });

    mapController.animateCamera(CameraUpdate.newLatLng(target));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() => _searchResults = []);
        },
        child: Stack(
          children: [
            /// Google Map
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 15.0),
              onCameraMove: _onCameraMove,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
            ),

            /// Search Bar + Results
            SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2))
                      ],
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child:
                              const Icon(Icons.arrow_back, color: Colors.black),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText:
                                  LocalizationHelper.tr.search_location_prompt,
                              border: InputBorder.none,
                              suffixIcon: _isSearching
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      ),
                                    )
                                  : null,
                            ),
                            onChanged: _onSearchChanged,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Search results dropdown
                  if (_searchResults.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2))
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final loc = _searchResults[index];
                          return ListTile(
                            leading: const Icon(Icons.location_on),
                            title: Text(loc.name),
                            onTap: () => _selectSearchResult(loc),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            /// Center Marker
            const Center(
              child:
                  Icon(Icons.location_on, size: 50, color: Colors.deepPurple),
            ),

            /// Bottom Info & Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0x66700034)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          padding: const EdgeInsets.all(10),
                          decoration: ShapeDecoration(
                            color: LightThemeColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Icon(Icons.warning_amber_rounded,
                              color: LightThemeColors.white, size: 28),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${LocalizationHelper.tr.delivery_location_info_message}/n ${LocalizationHelper.tr.delivery_agent_help_message}',
                            style:
                                const TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ButtonWidget(
                    onTap: _pickLocation,
                    title: LocalizationHelper.tr.use_location_action,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
