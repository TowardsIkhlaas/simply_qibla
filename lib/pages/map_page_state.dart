part of 'map_page.dart';

class MapPageState extends State<MapPage> {
  // State Declaration and Variables

  late GoogleMapController mapController;
  LatLng? userLocation;
  MapType _currentMapType = MapType.normal;
  bool _isCameraMoving = false;
  bool _enableLocationButton = true;
  CenterConsoleState _centerConsoleState = CenterConsoleState.idle;
  final Set<Polyline> _polylines = <Polyline>{};
  CameraPosition _currentCameraPosition = const CameraPosition(
    target: MapConstants.defaultPosition,
    zoom: MapConstants.zoomLevel,
  );

  // Build Method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const SQAppBar(),
      body: buildMapBody(context),
      bottomNavigationBar: buildBottomBar(context),
    );
  }

  // Event Handlers and Callbacks

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    if (userLocation != null) {
      animateToLocation(userLocation!);
    } else {
      centerMapToUserLocation();
    }
  }

  void handleChangeLocation(LatLng coordinates) {
    animateToLocation(coordinates);
  }

  void animateToLocation(LatLng coordinates) async {
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: coordinates, zoom: MapConstants.zoomLevel)),
    );

    setState(() {
      _centerConsoleState = CenterConsoleState.idle;
      _enableLocationButton = true;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar(
        AppStrings.locationDisabled,
        actionLabel: 'TURN ON',
        action: () => Geolocator.openLocationSettings(),
      );
      return Future<Position>.error(AppStatusCodes.locationDisabled);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar(
          AppStrings.locationDeniedInitial,
        );
        return Future<Position>.error(AppStatusCodes.locationDeniedInitial);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar(
        AppStrings.locationDeniedPermanent,
        actionLabel: 'ALLOW',
        action: () => Geolocator.openAppSettings(),
      );
      return Future<Position>.error(AppStatusCodes.locationDeniedPermanent);
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> centerMapToUserLocation() async {
    try {
      setState(() {
        _centerConsoleState = CenterConsoleState.centering;
        _enableLocationButton = false;
      });

      Position currentLocation = await _determinePosition();

      userLocation = LatLng(
        currentLocation.latitude,
        currentLocation.longitude,
      );

      animateToLocation(userLocation!);
    } catch (e) {
      setState(() {
        _centerConsoleState = CenterConsoleState.idle;
        _enableLocationButton = true;
      });
      debugPrint('Error getting user location: $e');
    }
  }

  // Helper Methods

  void _showSnackBar(String message,
      {String? actionLabel, VoidCallback? action}) {
    final SnackBar snackBar = SnackBar(
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

  void _updatePolyline(LatLng from, LatLng to) {
    const String polylineIdVal = 'polyline_center_to_qibla';
    final Polyline polyline = Polyline(
      polylineId: const PolylineId(polylineIdVal),
      width: MapConstants.polylineWidth,
      color: Colors.amber,
      points: <LatLng>[from, to],
      geodesic: true,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );
    setState(() {
      _polylines.removeWhere(
          (Polyline poly) => poly.polylineId.value == polylineIdVal);
      _polylines.add(polyline);
    });
  }

  void _onCameraMoveStarted() {
    setState(() {
      _isCameraMoving = true;
      _polylines.clear();
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _centerConsoleState = CenterConsoleState.dragging;
      _currentCameraPosition = position;
    });
  }

  Future<void> _onCameraIdle() async {
    setState(() {
      _centerConsoleState = CenterConsoleState.idle;
      _isCameraMoving = false;
      _updatePolyline(
          _currentCameraPosition.target, MapConstants.qiblaPosition);
    });
  }

  Widget buildMap() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.standard),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              polylines: _polylines,
              mapType: _currentMapType,
              zoomControlsEnabled: false,
              initialCameraPosition: _currentCameraPosition,
              onCameraMoveStarted: _onCameraMoveStarted,
              onCameraMove: (CameraPosition position) =>
                  _onCameraMove(position),
              onCameraIdle: _onCameraIdle,
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

  Widget buildMapBody(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          CoordinatesFormBar(onCoordinatesSubmit: handleChangeLocation),
          Expanded(child: buildMap()),
        ],
      ),
    );
  }

  Widget buildBottomBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.standard),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () => <void>{
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
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppPadding.standard),
                child: CenterConsole(
                  state: _centerConsoleState,
                  currentCameraPosition: _currentCameraPosition,
                  isCameraMoving: _isCameraMoving,
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: _enableLocationButton
                  ? () async => centerMapToUserLocation()
                  : null,
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
