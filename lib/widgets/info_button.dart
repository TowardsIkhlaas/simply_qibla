import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:simply_qibla/styles/style.dart';

class InfoButton extends StatelessWidget {
  // final String distanceToKaaba;
  // final VoidCallback onCenterMap;

  const InfoButton({
    super.key,
    // required this.distanceToKaaba,
    // required this.onCenterMap,
  });

  void _showInfoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(AppPadding.standard),
            constraints: const BoxConstraints(maxHeight: 700),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "Distance to Kaaba:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Text("3578 km"),
                const SizedBox(height: 20),
                const Text(
                  "Developer Info",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Text("Developed by [Your Name]"),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showInfoModal(context),
      highlightColor: Colors.grey,
      icon: const Icon(
        TablerIcons.info_circle,
        size: 26,
        color: Colors.white,
      ),
    );
  }
}