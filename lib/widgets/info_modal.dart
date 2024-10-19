import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    applicationName: AppLocalizations.of(context)!.appNamePascalCase,
    applicationIcon: _buildAppIcon(),
    applicationVersion: 'v$version',
    applicationLegalese: AppLocalizations.of(context)!.appAboutLegalese,
    children: <Widget>[
      _buildTextSection('Build: $buildNumber'),
      _buildTextSection(AppLocalizations.of(context)!.thankYouText, isBold: true),
      _buildTextSection(AppLocalizations.of(context)!.supportAppealText),
      _buildButtonColumn(context),
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

Widget _buildButtonColumn(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(
      top: AppPadding.standard,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildLinkIconButton(
          onPressed: () async {
            await _shareApp(context);
          },
          labelText: AppLocalizations.of(context)!.shareButtonText,
          icon: Platform.isIOS ? TablerIcons.share_2 : TablerIcons.share,
        ),
        _buildLinkIconButton(
          onPressed: () async => launchUrlHelper(Uri.parse(AppStrings.donateUriPath)),
          labelText: AppLocalizations.of(context)!.donateButtonText,
          icon: TablerIcons.coffee,
          foregroundColor: AppThemes.donationServicePrimaryColor,
          backgroundColor: AppThemes.donationServiceSecondaryColor,
        ),
        _buildLinkIconButton(
          onPressed: () async => launchUrlHelper(Uri.parse(AppStrings.githubUriPath)),
          labelText: AppLocalizations.of(context)!.githubButtonText,
          icon: TablerIcons.brand_github,
          foregroundColor: AppThemes.githubPrimaryColor,
          backgroundColor: AppThemes.githubSecondaryColor,
        ),
        _buildLinkIconButton(
          onPressed: () async => launchUrlHelper(Uri.parse(AppStrings.socialInstagramUriPath)),
          labelText: AppLocalizations.of(context)!.socialInstagramButtonText,
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

Future<void> _shareApp(BuildContext context) async {
  String shareString = '${AppLocalizations.of(context)!.shareContentText}: ${AppStrings.landingPageLink}';
  await Share.share(shareString);
}
