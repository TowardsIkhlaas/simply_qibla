import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simply_qibla/styles/style.dart';
import 'package:simply_qibla/widgets/settings_modal.dart';

class SettingsButton extends StatefulWidget {
  const SettingsButton({
    super.key,
    this.onCompassSettingChanged,
    this.onThemeChanged,
    this.onColorChanged,
  });

  final VoidCallback? onCompassSettingChanged;
  final ValueChanged<String>? onThemeChanged;
  final ValueChanged<String>? onColorChanged;

  @override
  State<SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
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
      onPressed: () => showSettingsModal(
        context,
        _version,
        _buildNumber,
        onCompassSettingChanged: widget.onCompassSettingChanged,
        onThemeChanged: widget.onThemeChanged,
        onColorChanged: widget.onColorChanged,
      ),
      highlightColor: Colors.grey,
      icon: Icon(
        TablerIcons.settings,
        size: AppDimensions.iconSizeMd,
        color: Theme.of(context).appBarTheme.iconTheme?.color ?? Colors.white,
        semanticLabel: 'Settings Button',
      ),
    );
  }
}
