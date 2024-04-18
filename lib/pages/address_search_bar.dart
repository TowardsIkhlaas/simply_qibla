import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressSearchBar extends StatefulWidget {
  const AddressSearchBar({super.key});

  @override
  State<AddressSearchBar> createState() => _AddressSearchBarState();
}

class _AddressSearchBarState extends State<AddressSearchBar> {
  // String? _searchingWithQuery;
  late Iterable<Widget> _lastOptions = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: SearchAnchor(
        isFullScreen: false,
        builder: (BuildContext context, SearchController controller) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.search),
                    label: const Text("Got an address? :)"),
                    onPressed: () {
                      controller.openView();
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    )
                  ),
                ),
              ),
            ]
          );
        },

        suggestionsBuilder: (BuildContext context, SearchController controller) async {
          // _searchingWithQuery = controller.text;
          // final List<String> options = (await API.search(_searchingWithQuery!).toList());

          // if (_searchingWithQuery != controller.text) {
          //   return _lastOptions;
          // }

          // _lastOptions = List<ListTile>.generate(options.length,
          //   (int index) {
          //     final String item = options[index];
          //     return ListTile(
          //       title: Text(item),
          //     );
          //   }
          // );

          return _lastOptions;
        },
      ),
    );
  }
}
