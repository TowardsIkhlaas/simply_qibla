import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simply_qibla/constants/constants.dart';
import 'package:simply_qibla/helpers/url_launcher_helper.dart';
import 'package:simply_qibla/styles/style.dart';
import 'package:simply_qibla/theme/theme.dart';
import 'package:simply_qibla/widgets/link_icon_button.dart';

void showInfoModal(BuildContext context, String version, String buildNumber) {
  showAboutDialog(
    context: context,
    applicationName: AppStrings.appNamePascalCase,
    applicationIcon: _buildAppIcon(),
    applicationVersion: 'v$version',
    applicationLegalese: AppStrings.appAboutLegalese,
    children: <Widget>[
      _buildTextSection('Build: $buildNumber'),
      _buildTextSection(AppStrings.thankYouText, isBold: true),
      _buildTextSection(AppStrings.supportAppealText),
      _buildButtonColumn(),
    ],
  );
}

Widget _buildAppIcon() {
  return Container(
    width: AppDimensions.iconSizeXl,
    height: AppDimensions.iconSizeXl,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
    ),
    clipBehavior: Clip.antiAlias,
    child: Image.asset('assets/app-icon/app-icon.png'),
  );
}

Widget _buildTextSection(String text, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.only(
      top: AppPadding.standard,
    ),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
}

Widget _buildButtonColumn() {
  return Padding(
    padding: const EdgeInsets.only(
      top: AppPadding.standard,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildLinkIconButton(
          onPressed: _shareApp,
          labelText: AppStrings.shareButtonText,
          icon: Platform.isIOS ? TablerIcons.share_2 : TablerIcons.share,
        ),
        _buildLinkIconButton(
          onPressed: () async => launchUrlHelper(Uri.parse(AppStrings.donateUriPath)),
          labelText: AppStrings.donateButtonText,
          icon: TablerIcons.coffee,
          foregroundColor: AppThemes.donationServicePrimaryColor,
          backgroundColor: AppThemes.donationServiceSecondaryColor,
        ),
        _buildLinkIconButton(
          onPressed: () async => launchUrlHelper(Uri.parse(AppStrings.githubUriPath)),
          labelText: AppStrings.githubButtonText,
          icon: TablerIcons.brand_github,
          foregroundColor: AppThemes.githubPrimaryColor,
          backgroundColor: AppThemes.githubSecondaryColor,
        ),
        _buildLinkIconButton(
          onPressed: () async => launchUrlHelper(Uri.parse(AppStrings.socialInstagramUriPath)),
          labelText: AppStrings.socialInstagramButtonText,
          icon: TablerIcons.brand_instagram,
          foregroundColor: AppThemes.socialInstagramPrimaryColor,
          backgroundColor: AppThemes.socialInstagramSecondaryColor,
        ),
      ],
    ),
  );
}

Widget _buildLinkIconButton({
  required VoidCallback onPressed,
  required String labelText,
  required IconData icon,
  Color? foregroundColor,
  Color? backgroundColor,
}) {
  return LinkIconButton(
    onPressed: onPressed,
    labelText: labelText,
    leadingIcon: Icon(icon, size: AppDimensions.iconSizeMd),
    buttonForegroundColor: foregroundColor,
    buttonBackgroundColor: backgroundColor,
  );
}

Future<void> _shareApp() async {
  const String shareString = '${AppStrings.shareContentText}: ${AppStrings.landingPageLink}';
  await Share.share(shareString);
}
