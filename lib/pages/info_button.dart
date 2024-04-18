import 'package:flutter/material.dart';

class InfoButton extends StatelessWidget {
  final String distanceToKaaba;
  final VoidCallback onCenterMap;

  const InfoButton({
    super.key,
    required this.distanceToKaaba,
    required this.onCenterMap,
  });

  void _showInfoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // Optional: style the dialog
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 700), // Adjust the size as needed
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Distance to Kaaba:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text("3578 km"), // Placeholder for dynamic data
                SizedBox(height: 20),
                Text(
                  "Developer Info",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text("Developed by [Your Name]"),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
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
    return FloatingActionButton(
      onPressed: () => _showInfoModal(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: const Icon(Icons.info),
      ),
    );
  }
}