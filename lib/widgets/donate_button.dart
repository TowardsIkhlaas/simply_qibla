import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:simply_qibla/constants/constants.dart';
import 'package:simply_qibla/styles/style.dart';
import 'package:simply_qibla/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class DonateButton extends StatelessWidget {
  DonateButton({super.key});

  final Uri _url = Uri.parse(AppStrings.donateUriPath);

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: const Text(AppStrings.donateButtonText),
      onPressed: _launchUrl,
      icon: const Icon(
        TablerIcons.coffee,
        size: AppDimensions.iconSizeMd,
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: AppThemes.donationServicePrimaryColor,
        backgroundColor: AppThemes.donationServiceSecondaryColor,
      )
    );
  }
}
