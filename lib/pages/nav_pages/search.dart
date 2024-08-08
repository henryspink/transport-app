import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:transport_app/pages/elements/stops.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late GoogleMapController _controller;
  static LatLng? userLocation;
  static PanelController panelController = PanelController();
  static TextEditingController searchController = TextEditingController();

  void getUserLocation() async {
    bool myLocationEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    if (!myLocationEnabled) {
      log("Location services are disabled");
      return;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log("Location permission denied");
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      log("Location permission denied forever");
      return;
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
      log("User location: $userLocation");
    });
    await _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: userLocation!, zoom: 14)));
  }

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(
          controller: searchController,
          hintText: "Search for a stop",
          onSubmitted: (String value) {
            log("Search for $value");
          },
        ),
      ),
      body: SlidingUpPanel(
        controller: panelController,
        minHeight: 100,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        snapPoint: 0.75,
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(target: userLocation ?? const LatLng(-37.8186, 144.9637), zoom: 14),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
            ..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer()))
        ),
        panelBuilder: (sc) {
          return NearbyStops(
            controller: sc,
            results: [],
            panelController: panelController
          );
        },
        borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      )
      ),
    );
  }
}