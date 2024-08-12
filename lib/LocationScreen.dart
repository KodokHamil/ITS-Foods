import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController _mapController;
  LatLng _initialPosition = LatLng(-6.200000, 106.816666); // Default to Jakarta, Indonesia
  LatLng? _currentPosition;
  bool _loading = true;
  String _locationMessage = "Fetching location...";
  Marker? _currentMarker;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Location services are disabled.";
        _loading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Location permissions are denied";
          _loading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = "Location permissions are permanently denied, we cannot request permissions.";
        _loading = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _initialPosition = _currentPosition!;
        _loading = false;
        _addMarker(_initialPosition, "Your Location");
      });
      _mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
    } catch (e) {
      setState(() {
        _locationMessage = "Failed to get current location: $e";
        _loading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      _mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
    }
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _addMarker(position, "Selected Location");
      _showLocationDetails(position);
    });
  }

  void _addMarker(LatLng position, String title) {
    final String markerIdVal = 'marker_id_1';
    _currentMarker = Marker(
      markerId: MarkerId(markerIdVal),
      position: position,
      infoWindow: InfoWindow(title: title),
      onTap: () {
        _showLocationDetails(position);
      },
    );
  }

  void _showLocationDetails(LatLng position) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Latitude: ${position.latitude}'),
              Text('Longitude: ${position.longitude}'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lokasi Anda'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _currentPosition == null
              ? Center(child: Text(_locationMessage))
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 14,
                  ),
                  myLocationEnabled: true,
                  markers: _currentMarker != null ? {_currentMarker!} : {},
                  onTap: _onMapTapped,
                ),
    );
  }
}
