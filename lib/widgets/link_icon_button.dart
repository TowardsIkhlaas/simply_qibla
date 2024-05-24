import 'package:flutter/material.dart';

class LinkIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String labelText;
  final Icon leadingIcon;
  final Color? buttonForegroundColor;
  final Color? buttonBackgroundColor;

  const LinkIconButton({
    super.key,
    required this.onPressed,
    required this.labelText,
    required this.leadingIcon,
    this.buttonForegroundColor,
    this.buttonBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        label: Text(labelText),
        onPressed: onPressed,
        icon: leadingIcon,
        style: ElevatedButton.styleFrom(
          foregroundColor: buttonForegroundColor,
          backgroundColor: buttonBackgroundColor,
        ));
  }
}
