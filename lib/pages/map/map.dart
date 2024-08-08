import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

class Map extends StatefulWidget {
  const Map({super.key});
  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static LatLng? userLocation;

  void getUserLocation() async {
    bool myLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!myLocationEnabled) {
      log("Location services are disabled");
      return;
      // return Future.error("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log("Location permission denied");
        return;
        // return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log("Location permission denied forever");
      return;
      // return Future.error("Location permission denied forever");
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // List<Placemark> placemark = await Geolocator.placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
      log("User location: $userLocation");
    });
    // LatLng(position.latitude, position.longitude);
  }

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(target: userLocation ?? const LatLng(0, 0), zoom: 14),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
            ..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer()))
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: const Text('To the lake!'),
          icon: const Icon(Icons.directions_boat),
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}