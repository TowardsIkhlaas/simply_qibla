part of 'map_page.dart';

class MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  String? _mapStyle;
  MapType _currentMapType = MapType.normal;
  LatLng qiblaCoordinates = const LatLng(
    DefaultCoordinates.qiblaLatitude,
    DefaultCoordinates.qiblaLongitude,
  );
  final LatLng _center = const LatLng(
    DefaultCoordinates.defaultLatitude,
    DefaultCoordinates.defaultLongitude,
  );
  final Set<Polyline> _polylines = <Polyline>{};

  @override
  void initState() {
    super.initState();
    loadMapStyle();
    centerMapToUserLocation();
  }

  void loadMapStyle() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      setState(() => _mapStyle = string);
    });
  }

  Future<void> centerMapToUserLocation() async {
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await handleLocationPermission(status);
    }
    if (status == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    var currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    LatLng currentLocationLatLng = LatLng(
      currentLocation.latitude,
      currentLocation.longitude,
    );

    animateToLocation(currentLocationLatLng);
  }

  Future<LocationPermission> handleLocationPermission(LocationPermission status) async {
    if (status == LocationPermission.denied) {
      return await Geolocator.requestPermission();
    }
    return status;
  }

  void animateToLocation(LatLng coordinates) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: coordinates, zoom: 19.0)),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    animateToLocation(_center);
  }

  void _updatePolyline(LatLng from, LatLng to) {
    const String polylineIdVal = 'polyline_center_to_qibla';
    _polylines.add(
      Polyline(
        polylineId: const PolylineId(polylineIdVal),
        width: 10,
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
          AddressSearchBar(onSuggestionSelected: handleAddressSelection),
          Expanded(child: buildMap()),
        ],
      ),
    );
  }

  Widget buildMap() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.standard),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              polylines: _polylines,
              style: _mapStyle,
              mapType: _currentMapType,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(target: _center, zoom: 19.0),
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

  void handleAddressSelection(LatLng coordinates) {
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
