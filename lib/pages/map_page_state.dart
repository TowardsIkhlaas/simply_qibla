part of 'map_page.dart';

class MapPageState extends State<MapPage> {
  // State Declaration and Variables

  late GoogleMapController mapController;
  LatLng? userLocation;
  MapType _currentMapType = MapType.normal;
  bool _isCameraMoving = false;
  bool _enableLocationButton = true;
  bool _compassEnabled = true;
  CenterConsoleState _centerConsoleState = CenterConsoleState.idle;
  final Set<Polyline> _polylines = <Polyline>{};
  CameraPosition _currentCameraPosition = const CameraPosition(
    target: MapConstants.defaultPosition,
    zoom: MapConstants.zoomLevel,
  );

  // Location tracking state
  LocationTrackingMode _locationTrackingMode = LocationTrackingMode.idle;
  StreamSubscription<CompassEvent>? _compassSubscription;
  double _lastAppliedBearing = 0.0;
  DateTime _lastBearingUpdateTime = DateTime.now();
  double _zoomBeforeRotation = MapConstants.zoomLevel;
  bool _isProgrammaticCameraMove = false;
  bool _pendingBearingReset = false; // Deferred bearing reset after drag exit from rotation mode
  LatLng? _lastPolylineTarget; // Track last polyline position to avoid redraws on bearing changes

  @override
  void initState() {
    super.initState();
    _loadCompassSetting();
  }

  void _loadCompassSetting() async {
    bool compassEnabled = await getCompassEnabled();
    setState(() {
      _compassEnabled = compassEnabled;
    });
  }

  @override
  void dispose() {
    unawaited(_compassSubscription?.cancel());
    super.dispose();
  }

  // Location Tracking Mode Methods

  Future<void> _onLocationFabPressed() async {
    switch (_locationTrackingMode) {
      case LocationTrackingMode.idle:
        await _centerAndTrack();
      case LocationTrackingMode.centered:
        _enableRotationMode();
      case LocationTrackingMode.rotating:
        _disableRotationMode();
    }
  }

  Future<void> _centerAndTrack() async {
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

      _isProgrammaticCameraMove = true;
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: userLocation!, zoom: MapConstants.zoomLevel),
        ),
      );

      setState(() {
        _centerConsoleState = CenterConsoleState.idle;
        _enableLocationButton = true;
        _locationTrackingMode = LocationTrackingMode.centered;
      });
    } catch (e, stackTrace) {
      setState(() {
        _centerConsoleState = CenterConsoleState.idle;
        _enableLocationButton = true;
        _locationTrackingMode = LocationTrackingMode.idle;
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

  void _enableRotationMode() {
    if (userLocation == null || !_compassEnabled) return;

    setState(() {
      _zoomBeforeRotation = _currentCameraPosition.zoom;
      _locationTrackingMode = LocationTrackingMode.rotating;
    });

    // Zoom in for rotation mode
    _isProgrammaticCameraMove = true;
    unawaited(mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: userLocation!,
          zoom: CompassConstants.rotationZoomLevel,
          bearing: _lastAppliedBearing,
        ),
      ),
    ));

    // Start listening to compass events
    unawaited(_compassSubscription?.cancel());
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      if (event.heading != null) {
        _applyBearingWithThrottle(event.heading!);
      }
    });
  }

  void _disableRotationMode({bool deferBearingReset = false}) {
    unawaited(_compassSubscription?.cancel());
    _compassSubscription = null;

    // Reset map bearing and zoom (defer if exiting via drag - will be done in onCameraIdle)
    if (userLocation != null && !deferBearingReset) {
      _isProgrammaticCameraMove = true;
      unawaited(mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentCameraPosition.target,
            zoom: _zoomBeforeRotation,
            bearing: 0,
          ),
        ),
      ));
    }

    // Stay in centered mode if still at user location
    final bool stillCentered = _isCenteredOnUserLocation();
    setState(() {
      _locationTrackingMode =
          stillCentered ? LocationTrackingMode.centered : LocationTrackingMode.idle;
      _lastAppliedBearing = 0.0;
    });
  }

  bool _isCenteredOnUserLocation() {
    if (userLocation == null) return false;
    final double latDiff =
        (_currentCameraPosition.target.latitude - userLocation!.latitude).abs();
    final double lngDiff =
        (_currentCameraPosition.target.longitude - userLocation!.longitude).abs();
    return latDiff < CompassConstants.positionThreshold &&
        lngDiff < CompassConstants.positionThreshold;
  }

  bool _hasPositionChangedSignificantly(LatLng newTarget) {
    if (_lastPolylineTarget == null) return true;
    final double latDiff =
        (newTarget.latitude - _lastPolylineTarget!.latitude).abs();
    final double lngDiff =
        (newTarget.longitude - _lastPolylineTarget!.longitude).abs();
    return latDiff > CompassConstants.positionThreshold ||
        lngDiff > CompassConstants.positionThreshold;
  }

  void _applyBearingWithThrottle(double heading) {
    if (_locationTrackingMode != LocationTrackingMode.rotating ||
        userLocation == null) {
      return;
    }

    final DateTime now = DateTime.now();
    final int elapsedMs = now.difference(_lastBearingUpdateTime).inMilliseconds;

    // Time throttle
    if (elapsedMs < CompassConstants.updateIntervalMs) return;

    // Bearing threshold (handle 360° wrap)
    double diff = (heading - _lastAppliedBearing).abs();
    if (diff > 180) diff = 360 - diff;
    if (diff < CompassConstants.bearingThreshold) return;

    _lastAppliedBearing = heading;
    _lastBearingUpdateTime = now;
    _isProgrammaticCameraMove = true;

    unawaited(mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: userLocation!,
          zoom: _currentCameraPosition.zoom,
          bearing: heading,
        ),
      ),
    ));
  }

  // Build Method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SQAppBar(
        onCompassSettingChanged: _loadCompassSetting,
        onThemeChanged: widget.onThemeChanged,
        onColorChanged: widget.onColorChanged,
      ),
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
    _isProgrammaticCameraMove = true;
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: coordinates, zoom: MapConstants.zoomLevel)),
    );

    setState(() {
      _centerConsoleState = CenterConsoleState.idle;
      _enableLocationButton = true;
      _locationTrackingMode = coordinates == userLocation
          ? LocationTrackingMode.centered
          : LocationTrackingMode.idle;
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
    await _centerAndTrack();
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
    // If not a programmatic move and we're in centered mode, user gestured - exit to idle
    // Note: In rotation mode, we detect drags in _onCameraMove by position change
    if (!_isProgrammaticCameraMove &&
        _locationTrackingMode == LocationTrackingMode.centered) {
      setState(() {
        _locationTrackingMode = LocationTrackingMode.idle;
      });
    }

    setState(() {
      _isCameraMoving = true;
      // Don't clear polylines in rotation mode - we're only changing bearing, not position
      if (_locationTrackingMode != LocationTrackingMode.rotating) {
        _polylines.clear();
      }
    });
  }

  void _onCameraMove(CameraPosition position) {
    // In rotation mode, detect user drag by position change (not just bearing)
    if (_locationTrackingMode == LocationTrackingMode.rotating &&
        userLocation != null) {
      final double latDiff =
          (position.target.latitude - userLocation!.latitude).abs();
      final double lngDiff =
          (position.target.longitude - userLocation!.longitude).abs();
      // Use a larger threshold to avoid false triggers from floating point drift
      if (latDiff > CompassConstants.dragDetectionThreshold ||
          lngDiff > CompassConstants.dragDetectionThreshold) {
        // Update position BEFORE disabling so animation uses correct target
        _currentCameraPosition = position;
        // Defer bearing reset until drag completes (in onCameraIdle)
        _pendingBearingReset = true;
        _disableRotationMode(deferBearingReset: true);
        return;
      }
    }

    setState(() {
      // Don't show "dragging" state in rotation mode - we're only changing bearing
      if (_locationTrackingMode != LocationTrackingMode.rotating) {
        _centerConsoleState = CenterConsoleState.dragging;
      }
      _currentCameraPosition = position;
    });
  }

  void _onCameraIdle() {
    // Don't reset programmatic flag in rotation mode - we're constantly making programmatic moves
    if (_locationTrackingMode != LocationTrackingMode.rotating) {
      _isProgrammaticCameraMove = false;
    }

    // Handle deferred bearing reset after drag exit from rotation mode
    if (_pendingBearingReset) {
      _pendingBearingReset = false;
      _isProgrammaticCameraMove = true;
      unawaited(mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentCameraPosition.target,
            zoom: _zoomBeforeRotation,
            bearing: 0,
          ),
        ),
      ));
    }

    // Only redraw polyline if position changed significantly (not just bearing)
    final bool shouldUpdatePolyline =
        _hasPositionChangedSignificantly(_currentCameraPosition.target);

    setState(() {
      _centerConsoleState = CenterConsoleState.idle;
      _isCameraMoving = false;
      if (shouldUpdatePolyline) {
        _lastPolylineTarget = _currentCameraPosition.target;
        _updatePolyline(
            _currentCameraPosition.target, MapConstants.qiblaPosition);
      }
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
              child: _compassEnabled
                  ? StreamBuilder<CompassEvent>(
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
                        // In rotation mode, icon doesn't rotate - map does
                        double iconRotation =
                            _locationTrackingMode == LocationTrackingMode.rotating
                                ? 0
                                : heading * (pi / 180);
                        return Transform.rotate(
                          angle: iconRotation,
                          child: UserLocationIcon(
                            primaryColor:
                                _locationTrackingMode != LocationTrackingMode.idle
                                    ? Colors.blueAccent
                                    : Colors.blueGrey,
                          ),
                        );
                      },
                    )
                  : Icon(
                      TablerIcons.circle_dot,
                      size: AppDimensions.iconSizeLg,
                      color: _locationTrackingMode != LocationTrackingMode.idle
                          ? Colors.blueAccent
                          : Colors.grey,
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
                elevation: 0,
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
                elevation: 0,
                backgroundColor: _locationTrackingMode == LocationTrackingMode.rotating
                    ? Theme.of(context).colorScheme.primary
                    : null,
                foregroundColor: _locationTrackingMode == LocationTrackingMode.rotating
                    ? Theme.of(context).colorScheme.onPrimary
                    : null,
                onPressed: _enableLocationButton
                    ? () async => _onLocationFabPressed()
                    : null,
                child: Icon(
                  _locationTrackingMode != LocationTrackingMode.idle
                      ? TablerIcons.compass
                      : TablerIcons.current_location,
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
