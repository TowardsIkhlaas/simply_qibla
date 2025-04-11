part of 'map_page.dart';

class MapPageState extends State<MapPage> {
  // State Declaration and Variables

  late GoogleMapController mapController;
  LatLng? userLocation;
  MapType _currentMapType = MapType.normal;
  bool _isCameraMoving = false;
  bool _enableLocationButton = true;
  bool _isMapCenteredOnUser = false;
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
    _requestReview();
  }

  void animateToLocation(LatLng coordinates) async {
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: coordinates, zoom: MapConstants.zoomLevel)),
    );

    setState(() {
      _centerConsoleState = CenterConsoleState.idle;
      _enableLocationButton = true;
      _isMapCenteredOnUser = coordinates == userLocation;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    final String locationDisabledMessage =
        AppLocalizations.of(context)!.locationDisabled;
    final String turnOnText = AppLocalizations.of(context)!.turnOnText;
    final String locationDeniedInitialMessage =
        AppLocalizations.of(context)!.locationDeniedInitial;
    final String locationDeniedPermanentMessage =
        AppLocalizations.of(context)!.locationDeniedPermanent;
    final String allowText = AppLocalizations.of(context)!.allowText;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar(
        locationDisabledMessage,
        actionLabel: turnOnText,
        action: () => Geolocator.openLocationSettings(),
      );
      return Future<Position>.error(AppStatusCodes.locationDisabled);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar(
          locationDeniedInitialMessage,
        );
        return Future<Position>.error(AppStatusCodes.locationDeniedInitial);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar(
        locationDeniedPermanentMessage,
        actionLabel: allowText,
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
    } catch (e, stackTrace) {
      setState(() {
        _centerConsoleState = CenterConsoleState.idle;
        _enableLocationButton = true;
      });

      if (!kReleaseMode) {
        developer.log(
          'Error getting user location: $e',
          name: 'location.error',
          error: stackTrace,
        );
      }
    }
  }

  Future<void> _requestReview() async {
    int launchCount = await getLaunchCount();

    if (launchCount >= 3 && launchCount % 3 == 0) {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
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
      _isMapCenteredOnUser = false;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _centerConsoleState = CenterConsoleState.dragging;
      _currentCameraPosition = position;
    });
  }

  void _onCameraIdle() {
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
              compassEnabled: true,
              rotateGesturesEnabled: false,
              myLocationButtonEnabled: false,
              polylines: _polylines,
              mapType: _currentMapType,
              zoomControlsEnabled: false,
              initialCameraPosition: _currentCameraPosition,
              onCameraMoveStarted: _onCameraMoveStarted,
              onCameraMove: (CameraPosition position) =>
                  _onCameraMove(position),
              onCameraIdle: _onCameraIdle,
            ),
            Center(
              child: StreamBuilder<CompassEvent>(
                stream: FlutterCompass.events,
                builder: (BuildContext context,
                    AsyncSnapshot<CompassEvent> snapshot) {
                  if (snapshot.hasError) {
                    return Icon(
                      TablerIcons.circle_dot,
                      size: AppDimensions.iconSizeLg,
                      color: Colors.black,
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return Icon(
                      TablerIcons.circle_dot,
                      size: AppDimensions.iconSizeLg,
                      color: Colors.black,
                    );
                  }

                  double heading = snapshot.data!.heading ?? 0;
                  return Transform.rotate(
                    angle: heading * (pi / 180),
                    child: UserLocationIcon(
                      primaryColor:
                          _isMapCenteredOnUser ? Colors.blue : Colors.grey,
                    ),
                  );
                },
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
          CoordinatesFormBar(onCoordinatesSubmit: animateToLocation),
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
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FloatingActionButton(
                heroTag: 'mapTypeToggle',
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
                  semanticLabel: 'Toggle map type',
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.standard),
                  child: CenterConsole(
                    state: _centerConsoleState,
                    currentCameraPosition: _currentCameraPosition,
                    isCameraMoving: _isCameraMoving,
                  ),
                ),
              ),
              FloatingActionButton(
                heroTag: 'centerMapToUser',
                onPressed: _enableLocationButton
                    ? () async => centerMapToUserLocation()
                    : null,
                child: const Icon(
                  TablerIcons.current_location,
                  size: AppDimensions.iconSizeLg,
                  semanticLabel: 'Center map to current location',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
