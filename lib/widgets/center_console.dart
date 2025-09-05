import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:simply_qibla/constants/constants.dart';
import 'package:simply_qibla/l10n/app_localizations.dart';
import 'package:simply_qibla/styles/style.dart';

class CenterConsole extends StatelessWidget {
  final CenterConsoleState state;
  final CameraPosition currentCameraPosition;
  final bool isCameraMoving;

  const CenterConsole({
    required this.state,
    required this.currentCameraPosition,
    required this.isCameraMoving,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color consoleColor;
    String text;
    int distanceAway = calculateDistance(
        currentCameraPosition.target, MapConstants.qiblaPosition);
    String formattedDistance =
        NumberFormat.decimalPattern().format(distanceAway);

    switch (state) {
      case CenterConsoleState.centering:
        consoleColor = Colors.green;
        text = AppLocalizations.of(context)!.centerConsoleCenteringText;
        break;
      case CenterConsoleState.dragging:
        consoleColor = Colors.blue;
        text = AppLocalizations.of(context)!.centerConsoleDraggingText;
        break;
      case CenterConsoleState.idle:
        consoleColor = Theme.of(context).colorScheme.primaryContainer;
        text =
            '$formattedDistance ${AppLocalizations.of(context)!.centerConsoleIdleText}';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        border: Border.all(
          color: consoleColor,
          width: 1,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: consoleColor.withValues(alpha: AppStyles.shadowOpacity),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: consoleColor,
          ),
        ),
      ),
    );
  }

  int calculateDistance(LatLng start, LatLng end) {
    double distance = Geolocator.distanceBetween(
        start.latitude, start.longitude, end.latitude, end.longitude);
    int distanceInKm = (distance / 1000).round();
    return distanceInKm;
  }
}
