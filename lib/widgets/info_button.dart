import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simply_qibla/constants/constants.dart';
import 'package:simply_qibla/helpers/url_launcher_helper.dart';
import 'package:simply_qibla/styles/style.dart';
import 'package:simply_qibla/theme/theme.dart';
import 'package:simply_qibla/widgets/link_icon_button.dart';

class InfoButton extends StatefulWidget {
  const InfoButton({super.key});

  @override
  State<InfoButton> createState() => _InfoButtonState();
}

class _InfoButtonState extends State<InfoButton> {
  late String _version;
  late String _buildNumber;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
  }

  void _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
      _isLoading = false;
    });
  }

  void _showInfoModal(BuildContext context) async {
    if (_isLoading) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: CircularProgressIndicator(),
          title: Text('Loading'),
        ),
      );
    } else {
      showAboutDialog(
        context: context,
        applicationName: AppStrings.appNamePascalCase,
        applicationIcon: Container(
          width: AppDimensions.iconSizeXl,
          height: AppDimensions.iconSizeXl,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadiusMd,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/app_icon/app_icon.png',
          ),
        ),
        applicationVersion: 'v$_version',
        applicationLegalese: AppStrings.appAboutLegalese,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppPadding.standard),
            child: Text('Build: $_buildNumber'),
          ),
          const SizedBox(
            height: AppPadding.standard,
          ),
          const Text(
            AppStrings.thankYouText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: AppPadding.standard,
          ),
          const Text(AppStrings.supportAppealText),
          const SizedBox(
            height: AppPadding.standard,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinkIconButton(
                onPressed: () async {
                  String shareString;
                  if (Platform.isIOS) {
                    shareString =
                        '${AppStrings.shareContentText}: ${AppStrings.iosAppLink}';
                  } else {
                    shareString =
                        '${AppStrings.shareContentText}: ${AppStrings.androidAppLink}';
                  }
                  await Share.share(shareString);
                },
                labelText: AppStrings.shareButtonText,
                leadingIcon: Icon(
                  Platform.isIOS ? TablerIcons.share_2 : TablerIcons.share,
                  size: AppDimensions.iconSizeMd,
                ),
              ),
              LinkIconButton(
                onPressed: () =>
                    launchUrlHelper(Uri.parse(AppStrings.donateUriPath)),
                labelText: AppStrings.donateButtonText,
                leadingIcon: const Icon(
                  TablerIcons.coffee,
                  size: AppDimensions.iconSizeMd,
                ),
                buttonForegroundColor: AppThemes.donationServicePrimaryColor,
                buttonBackgroundColor: AppThemes.donationServiceSecondaryColor,
              ),
              LinkIconButton(
                onPressed: () =>
                    launchUrlHelper(Uri.parse(AppStrings.githubUriPath)),
                labelText: AppStrings.githubButtonText,
                leadingIcon: const Icon(
                  TablerIcons.brand_github,
                  size: AppDimensions.iconSizeMd,
                ),
                buttonForegroundColor: AppThemes.githubPrimaryColor,
                buttonBackgroundColor: AppThemes.githubSecondaryColor,
              ),
            ],
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showInfoModal(context),
      highlightColor: Colors.grey,
      icon: const Icon(
        TablerIcons.info_circle,
        size: AppDimensions.iconSizeMd,
        color: Colors.white,
      ),
    );
  }
}
