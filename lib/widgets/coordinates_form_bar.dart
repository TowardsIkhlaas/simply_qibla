import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:simply_qibla/widgets/coordinates_input_form.dart';
import 'package:simply_qibla/constants/constants.dart';
import 'package:simply_qibla/styles/style.dart';

class CoordinatesFormBar extends StatefulWidget {
  final Function(LatLng) onCoordinatesSubmit;

  const CoordinatesFormBar({
    super.key,
    required this.onCoordinatesSubmit,
  });

  @override
  State<CoordinatesFormBar> createState() => _CoordinatesFormBarState();
}

class _CoordinatesFormBarState extends State<CoordinatesFormBar> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  @override
  void dispose() {
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void showLatLngDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => CoordinatesInputForm(
                formKey: _formKey,
                latitudeController: latitudeController,
                longitudeController: longitudeController,
                onCoordinatesSubmit: widget.onCoordinatesSubmit,
              ));
    }

    return Container(
      padding: const EdgeInsets.all(AppPadding.standard),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: AppDimensions.pillBarSize,
              child: ElevatedButton.icon(
                icon: const Icon(
                  TablerIcons.search,
                  size: AppDimensions.iconSizeSm,
                ),
                label: const Text(AppStrings.changeLocationBarText),
                onPressed: () => showLatLngDialog(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
