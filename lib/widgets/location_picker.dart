import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  LocationPicker(this.initialLat, this.initialLng);
  @override
  _LocationPickerState createState() =>
      _LocationPickerState(initialLat, initialLng);
}

class _LocationPickerState extends State<LocationPicker> {
  GoogleMapController? _mapController;
  final double? initialLat;
  final double? initialLng;
  LatLng _currentPosition = LatLng(0, 0);
  LatLng? _selectedLocation;

  _LocationPickerState(this.initialLat, this.initialLng);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _determineInitialPosition();
  }

  Future<void> _determineInitialPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    LatLng initialPostion;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    debugPrint('initialLat: $initialLat');
    debugPrint('initialLng: $initialLng');

    if (initialLat != null && initialLng != null) {
      initialPostion = LatLng(initialLat!, initialLng!);
    } else {
      Position position = await Geolocator.getCurrentPosition();
      initialPostion = LatLng(position.latitude, position.longitude);
    }

    setState(() {
      _currentPosition = initialPostion;
    });

    // Update the map's camera to focus on the current position
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: initialPostion,
          zoom: 11.0,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // If _currentPosition is not the default (0, 0), set the marker and update the camera
    if (_currentPosition.latitude != 0 && _currentPosition.longitude != 0) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentPosition,
            zoom: 11.0,
          ),
        ),
      );
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('currentPos'),
            position: _currentPosition,
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      });
    }
  }

  void _handleSelectLocation(LatLng location) {
    setState(() {
      _markers.clear(); // Remove the old marker
      _markers.add(
        Marker(
          markerId: MarkerId('selectedPos'),
          position: location,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      _selectedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle the back button tap
            Navigator.pop(context,
                _selectedLocation); // Return the selected location, or null if none
          },
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 11.0,
        ),
        markers: _markers,
        onTap: _handleSelectLocation,
      ),
    );
  }
}
