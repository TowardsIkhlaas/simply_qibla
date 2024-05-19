part of 'map_page.dart';

class MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  LatLng? userLocation;
  MapType _currentMapType = MapType.normal;
  final Set<Polyline> _polylines = <Polyline>{};
  final LatLng _center = const LatLng(
    MapConstants.defaultLatitude,
    MapConstants.defaultLongitude,
  );
  LatLng qiblaCoordinates = const LatLng(
    MapConstants.qiblaLatitude,
    MapConstants.qiblaLongitude,
  );

  void _showSnackBar(String message,
      {String? actionLabel, VoidCallback? action}) {
    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXs),
      ),
      action: actionLabel != null && action != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: action,
            )
          : null,
    );
    snackbarKey.currentState?.showSnackBar(snackBar);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar(
        'Your location is off.',
        actionLabel: 'ENABLE',
        action: () => Geolocator.openLocationSettings(),
      );
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar(
          'Please allow the app to use your location. Your data is not collected or sold.',
        );
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar(
        'Please allow location permission for the app to use this function.',
        actionLabel: 'ALLOW',
        action: () => Geolocator.openAppSettings(),
      );
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> centerMapToUserLocation() async {
    try {
      Position currentLocation = await _determinePosition();

      userLocation = LatLng(
        currentLocation.latitude,
        currentLocation.longitude,
      );

      animateToLocation(userLocation!);
    } catch (e) {
      debugPrint('Error getting user location: $e');
    }
  }

  Future<LocationPermission> handleLocationPermission(
      LocationPermission status) async {
    if (status == LocationPermission.denied) {
      return await Geolocator.requestPermission();
    }
    return status;
  }

  void animateToLocation(LatLng coordinates) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: coordinates, zoom: MapConstants.zoomLevel)),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (userLocation != null) {
      animateToLocation(userLocation!);
    } else {
      centerMapToUserLocation();
    }
  }

  void _updatePolyline(LatLng from, LatLng to) {
    const String polylineIdVal = 'polyline_center_to_qibla';
    _polylines.add(
      Polyline(
        polylineId: const PolylineId(polylineIdVal),
        width: MapConstants.polylineWidth,
        color: Colors.amber,
        points: [from, to],
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const SQAppBar(),
      body: buildMapBody(context),
      bottomNavigationBar: buildBottomBar(context),
    );
  }

  Widget buildMapBody(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CoordinatesFormBar(onCoordinatesSubmit: handleChangeLocation),
          Expanded(child: buildMap()),
        ],
      ),
    );
  }

  Widget buildMap() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.standard),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              polylines: _polylines,
              mapType: _currentMapType,
              zoomControlsEnabled: false,
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: MapConstants.zoomLevel),
              onCameraMove: (CameraPosition position) {
                _updatePolyline(position.target, qiblaCoordinates);
              },
            ),
            const Center(
              child: Icon(
                TablerIcons.current_location,
                size: AppDimensions.iconSizeLg,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleChangeLocation(LatLng coordinates) {
    animateToLocation(coordinates);
  }

  Widget buildBottomBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.standard),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () => {
                setState(() {
                  _currentMapType = (_currentMapType == MapType.normal)
                      ? MapType.hybrid
                      : MapType.normal;
                })
              },
              child: const Icon(
                TablerIcons.map,
                size: AppDimensions.iconSizeLg,
              ),
            ),
            FloatingActionButton(
              onPressed: () => centerMapToUserLocation(),
              child: const Icon(
                TablerIcons.current_location,
                size: AppDimensions.iconSizeLg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
