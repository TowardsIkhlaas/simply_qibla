import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simply_qibla/widgets/info_modal.dart';
import 'package:simply_qibla/styles/style.dart';

class InfoButton extends StatefulWidget {
  const InfoButton({super.key});

  @override
  State<InfoButton> createState() => _InfoButtonState();
}

class _InfoButtonState extends State<InfoButton> {
  late String _version;
  late String _buildNumber;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showInfoModal(context, _version, _buildNumber),
      highlightColor: Colors.grey,
      icon: const Icon(
        TablerIcons.info_circle,
        size: AppDimensions.iconSizeMd,
        color: Colors.white,
      ),
    );
  }
}
