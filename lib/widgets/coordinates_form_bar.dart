import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simply_qibla/styles/style.dart';
import 'package:simply_qibla/widgets/coordinates_input_form.dart';

class CoordinatesFormBar extends StatefulWidget {
  final Function(LatLng) onCoordinatesSubmit;

  const CoordinatesFormBar({
    required this.onCoordinatesSubmit,
    super.key,
  });

  @override
  State<CoordinatesFormBar> createState() => _CoordinatesFormBarState();
}

class _CoordinatesFormBarState extends State<CoordinatesFormBar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    void showLatLngDialog(BuildContext context) async {
      showDialog(
          context: context,
          builder: (BuildContext context) => CoordinatesInputForm(
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
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: AppDimensions.pillBarSize,
              child: ElevatedButton.icon(
                icon: const Icon(
                  TablerIcons.search,
                  size: AppDimensions.iconSizeSm,
                ),
                label:
                    Text(AppLocalizations.of(context)!.changeLocationBarText),
                onPressed: () => showLatLngDialog(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
