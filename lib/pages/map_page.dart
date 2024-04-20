import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:simply_qibla/compositions/sq_app_bar.dart';
import 'package:simply_qibla/pages/address_search_bar.dart';
import 'package:simply_qibla/pages/info_button.dart';

class MapPage extends StatefulWidget {
  static const double defaultLatitude = 21.41940349340265;
  static const double defaultLongitude = 39.82562665088553;
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final Set<Polyline> _polylines = <Polyline>{};
  LatLng qiblaCoordinates = const LatLng(21.42253495661983, 39.82618860061329);
  final LatLng _center = const LatLng(
    MapPage.defaultLatitude,
    MapPage.defaultLongitude,
  );
  final Set<Circle> _circles = {
    const Circle(
      circleId: CircleId("offlineCircle"),
      center: LatLng(
        MapPage.defaultLatitude,
        MapPage.defaultLongitude,
      ),
      radius: 10,
      fillColor: Colors.black,
      strokeWidth: 4,
      strokeColor: Colors.white,
      zIndex: 10000,
    ),
  };

  @override
  void initState() {
    _centerMapToUserLocation();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _updatePolyline(LatLng from, LatLng to) {
    const String polylineIdVal = 'polyline_center_to_qibla';

    _polylines.add(
      Polyline(
        polylineId: const PolylineId(polylineIdVal),
        width: 10,
        color: const Color.fromARGB(255, 0, 187, 255),
        points: [from, to],
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    );

    // Rebuild to show the new polyline
    setState(() {});
  }

  Future<void> _centerMapToUserLocation() async {
    var status = await Geolocator.checkPermission();

    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
      if (status == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied.');
      }
    }

    if (status == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var currentLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 19.0,
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const SQAppBar(),
      body: Center(
        child: Column(
          children: [
            const AddressSearchBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20,),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 17.0,
                    ),
                    zoomControlsEnabled: false,
                    polylines: _polylines,
                    onCameraMove: (CameraPosition position) {
                      LatLng newCenter = position.target;
                      _updatePolyline(newCenter, qiblaCoordinates);
                    },
                    circles: _circles,
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoButton(
                      distanceToKaaba: "3578 km", // This would be dynamic in a real app
                      onCenterMap: _centerMapToUserLocation,
                    ),
                    FloatingActionButton(
                      onPressed: _centerMapToUserLocation,
                      child: const Icon(Icons.my_location),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
