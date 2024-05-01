import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simply_qibla/styles/style.dart';

class InfoButton extends StatefulWidget {
  const InfoButton({
    super.key,
    // required this.distanceToKaaba,
  });

  @override
  State<InfoButton> createState() => _InfoButtonState();
}

class _InfoButtonState extends State<InfoButton> {
  late String _appName;
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
      _appName = packageInfo.appName;
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
          title: Text("Loading"),
        ),
      );
    } else {
      showAboutDialog(
        context: context,
        applicationName: _appName,
        applicationIcon: const Icon(TablerIcons.location),
        applicationVersion: 'v$_version',
        applicationLegalese: '© 2024 TowardsIkhlaas',
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppPadding.standard),
            child: Text('Build: $_buildNumber'),
          ),
        ]
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
