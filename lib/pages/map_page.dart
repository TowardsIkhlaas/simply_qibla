import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:simply_qibla/widgets/coordinates_form_bar.dart';
import 'package:simply_qibla/widgets/sq_app_bar.dart';
import 'package:simply_qibla/constants/constants.dart';
import 'package:simply_qibla/styles/style.dart';

part 'map_page_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  MapPageState createState() => MapPageState();
}
