import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simply_qibla/services/place_service.dart';
import 'package:uuid/uuid.dart';
import 'package:simply_qibla/styles/style.dart';
import 'package:simply_qibla/utils/debouncer.dart';

class AddressSearchBar extends StatefulWidget {
  final Function(LatLng) onSuggestionSelected;

  const AddressSearchBar({
    super.key,
    required this.onSuggestionSelected,
  });

  @override
  State<AddressSearchBar> createState() => _AddressSearchBarState();
}

class _AddressSearchBarState extends State<AddressSearchBar> {
  String? _currentQuery;
  late Iterable<Widget> _lastOptions = <Widget>[];
  late final Debounceable<List<Suggestion>?, String> _debouncedSearch;
  PlaceApiProvider? _placeApi;
  String? _sessionToken;

  @override
  void initState() {
    super.initState();
    _debouncedSearch = debounce<List<Suggestion>?, String>(_search);
  }

  @override
  void dispose() {
    _sessionToken = null;
    _placeApi = null;
    super.dispose();
  }

  Future<List<Suggestion>?> _search(String query) async {
    _currentQuery = query;

    if (_placeApi == null) {
      debugPrint('Place API provider not initialized.');
      return null;
    }

    // In a real application, there should be some error handling here.
    final List<Suggestion> options = await _placeApi!.fetchSuggestions(
        _currentQuery!, Localizations.localeOf(context).languageCode);

    if (_currentQuery != query) {
      return null;
    }
    _currentQuery = null;

    return options;
  }

  void _startSearchSession() {
    _sessionToken = const Uuid().v4();
    _placeApi = PlaceApiProvider(_sessionToken);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(AppPadding.standard),
      child: SearchAnchor(
        isFullScreen: false,
        viewConstraints: BoxConstraints(
          maxHeight: screenHeight * AppDimensions.suggestionsHeightMultiplier,
        ),
        builder: (BuildContext context, SearchController controller) {
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    TablerIcons.search,
                    size: 18.0,
                  ),
                  label: const Text("Got a specific address? :)"),
                  onPressed: () {
                    _startSearchSession();
                    controller.openView();
                  },
                ),
              ),
            ),
          ]);
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) async {
          _currentQuery = controller.text;
          final List<Suggestion>? options =
              (await _debouncedSearch(controller.text))?.toList();
          if (options == null) {
            return _lastOptions;
          }

          _lastOptions = List<ListTile>.generate(options.length, (int index) {
            final Suggestion item = options[index];
            return ListTile(
                title: Text(item.description),
                onTap: () async {
                  LatLng latLng =
                      await _placeApi!.getPlaceCoordinatesFromId(item.placeId);
                  widget.onSuggestionSelected(latLng);
                  controller.closeView(null);
                });
          });

          return _lastOptions;
        },
      ),
    );
  }
}
