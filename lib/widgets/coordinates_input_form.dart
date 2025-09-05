import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simply_qibla/constants/constants.dart';
import 'package:simply_qibla/l10n/app_localizations.dart';
import 'package:simply_qibla/styles/style.dart';

class CoordinatesInputForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final Function(LatLng) onCoordinatesSubmit;

  const CoordinatesInputForm({
    required this.formKey,
    required this.latitudeController,
    required this.longitudeController,
    required this.onCoordinatesSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.coordinatesInputFormTitle,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Directionality(
              textDirection: TextDirection.ltr,
              child: TextFormField(
                autofocus: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: latitudeController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.latitudeFieldLabel,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.borderRadiusSm),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                validator: (String? value) {
                  if (InputValidation.latitudeValidatorPattern
                      .hasMatch(value!)) {
                    return null;
                  }
                  return AppLocalizations.of(context)!.latitudeErrorText;
                },
              ),
            ),
            const SizedBox(
              height: AppPadding.standard,
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: longitudeController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.longitudeFieldLabel,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.borderRadiusSm),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                validator: (String? value) {
                  if (InputValidation.longitudeValidatorPattern
                      .hasMatch(value!)) {
                    return null;
                  }
                  return AppLocalizations.of(context)!.longitudeErrorText;
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.clearText),
              onPressed: () {
                latitudeController.clear();
                longitudeController.clear();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancelText),
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
              child: Text(AppLocalizations.of(context)!.okText),
            ),
          ],
        ),
      ],
    );
  }
}
