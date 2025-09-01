import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:simply_qibla/l10n/app_localizations.dart';
import 'package:simply_qibla/pages/map_page.dart';

class MockGoogleMapController extends Mock implements GoogleMapController {}

void main() {
  group('MapPage', () {
    Future<void> pumpMapPage(WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MapPage(),
        ),
      );

      // Allow the map to render
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('Toggles map type when the toggle button is pressed',
        (WidgetTester tester) async {
      await pumpMapPage(tester);

      // Verify initial map type is normal
      final GoogleMap googleMap = tester.widget(find.byType(GoogleMap));
      expect(googleMap.mapType, MapType.normal);

      // Tap the toggle button
      await tester.tap(find.byIcon(TablerIcons.map));
      await tester.pump(const Duration(
          milliseconds: 300)); // Add a short delay for the tap action

      // Verify map type is changed to hybrid
      final GoogleMap googleMapAfterFirstTap =
          tester.widget(find.byType(GoogleMap));
      expect(googleMapAfterFirstTap.mapType, MapType.hybrid);

      // Tap the toggle button again
      await tester.tap(find.byIcon(TablerIcons.map));
      await tester.pump(const Duration(
          milliseconds: 300)); // Add a short delay for the tap action

      // Verify map type is changed back to normal
      final GoogleMap googleMapAfterSecondTap =
          tester.widget(find.byType(GoogleMap));
      expect(googleMapAfterSecondTap.mapType, MapType.normal);
    });
  });
}
