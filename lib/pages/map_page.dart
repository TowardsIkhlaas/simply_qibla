import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:simply_qibla/constants/constants.dart';
import 'package:simply_qibla/globals/globals.dart';
import 'package:simply_qibla/helpers/shared_preferences_helper.dart';
import 'package:simply_qibla/styles/style.dart';
import 'package:simply_qibla/widgets/center_console.dart';
import 'package:simply_qibla/widgets/coordinates_form_bar.dart';
import 'package:simply_qibla/widgets/sq_app_bar.dart';

part 'map_page_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}
