import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:safe_ship/Widgets/constant.dart';
import 'package:safe_ship/Widgets/navigation_widget.dart';

import 'home_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  final Location _location = Location();
  Map<PolylineId, Polyline> polylines = {};
  BitmapDescriptor? _sourceMarker;
  BitmapDescriptor? _destinationMarker;
  BitmapDescriptor? _currentLocationMarker;

  @override
  void initState() {
    super.initState();
    _getLocationPermission();
    getPolyPoints();
    _loadCustomMarkers();
  }

  Future<void> _loadCustomMarkers() async {
    _sourceMarker = await _createCustomMarker('assets/home.png');
    _destinationMarker = await _createCustomMarker('assets/store.png');
    _currentLocationMarker = await _createCustomMarker('assets/delivery.png');
    setState(() {});
  }


  List<LatLng> polylineCoordinates = [];

  _addPolyLine() {
    if (polylineCoordinates.isNotEmpty) {
      print("Adding polyline with ${polylineCoordinates.length} points");
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue, // Changed to blue for visibility
        width: 5, // Adjusted the width for better visibility
        points: polylineCoordinates,
      );
      setState(() {
        polylines[id] = polyline;
      });
    } else {
      print("No polyline points available to add.");
    }
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    // Debugging print to ensure function is called
    print("Fetching polyline points...");

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: google_api_key,
      request: PolylineRequest(
        origin: PointLatLng(scourceLocation.latitude, scourceLocation.longitude),
        destination: PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.status == 'OK') {
      for (PointLatLng point in result.points) {
        print('Adding point: (${point.latitude}, ${point.longitude})');
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print('Error fetching polyline points: ${result.errorMessage}');
    }

    _addPolyLine();
  }

  Future<void> _getLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentLocation = currentLocation;
      });

      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLng(
            LatLng(currentLocation.latitude!, currentLocation.longitude!)));
      }
    });
  }

  static const LatLng scourceLocation = LatLng(12.967603, 77.670065);
  static const LatLng destinationLocation = LatLng(12.968715, 77.674019);

  Future<BitmapDescriptor> _createCustomMarker(String imagePath) async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(28, 28)), // Adjust the size if needed
      imagePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.navigateToScreen(child: HomeScreen());
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        zoomControlsEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        polylines: Set<Polyline>.of(polylines.values),
        initialCameraPosition: CameraPosition(
          target: LatLng(
              _currentLocation!.latitude!, _currentLocation!.longitude!),
          zoom: 15,
        ),
        myLocationButtonEnabled: true,
        markers: {
          Marker(
              markerId: const MarkerId("_sourceLocation"),
              icon: _sourceMarker!,
              position: scourceLocation),
          Marker(
            markerId: const MarkerId("_currentLocation"),
            icon: _currentLocationMarker!,
            position: LatLng(_currentLocation!.latitude!,
                _currentLocation!.longitude!),
          ),
          Marker(
            markerId: const MarkerId("_destinationLocation"),
            icon: _destinationMarker!,
            position: destinationLocation,
          ),
        },
      ),
    );
  }
}
