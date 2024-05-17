import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkIconButton extends StatelessWidget {
  final Uri url;
  final String labelText;
  final Icon leadingIcon;
  final Color buttonForegroundColor;
  final Color buttonBackgroundColor;

  const LinkIconButton({
    super.key,
    required this.url,
    required this.labelText,
    required this.leadingIcon,
    required this.buttonForegroundColor,
    required this.buttonBackgroundColor,
  });

  Future<void> _launchUrl() async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        label: Text(labelText),
        onPressed: _launchUrl,
        icon: leadingIcon,
        style: ElevatedButton.styleFrom(
          foregroundColor: buttonForegroundColor,
          backgroundColor: buttonBackgroundColor,
        ));
  }
}
