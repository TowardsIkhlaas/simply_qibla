import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simply_qibla/constants/constants.dart';
import 'package:simply_qibla/styles/style.dart';

class CoordinatesInputForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final Function(LatLng) onCoordinatesSubmit;

  const CoordinatesInputForm({
    super.key,
    required this.formKey,
    required this.latitudeController,
    required this.longitudeController,
    required this.onCoordinatesSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Enter Coordinates',
        style: GoogleFonts.inter(
          textStyle: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              autofocus: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: latitudeController,
              decoration: InputDecoration(
                labelText: 'Latitude',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadiusSm),
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (InputValidation.latitudeValidatorPattern.hasMatch(value!)) {
                  return null;
                }
                return 'Invalid latitude value';
              },
            ),
            const SizedBox(
              height: AppPadding.standard,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: longitudeController,
              decoration: InputDecoration(
                labelText: 'Longitude',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadiusSm),
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (InputValidation.longitudeValidatorPattern
                    .hasMatch(value!)) {
                  return null;
                }
                return 'Invalid longitude value';
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: const Text('Clear'),
              onPressed: () {
                latitudeController.clear();
                longitudeController.clear();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                double? latitude = double.tryParse(latitudeController.text);
                double? longitude = double.tryParse(longitudeController.text);
                if (latitude != null &&
                    longitude != null &&
                    formKey.currentState!.validate()) {
                  LatLng coordinates = LatLng(latitude, longitude);
                  onCoordinatesSubmit(coordinates);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ],
    );
  }
}
