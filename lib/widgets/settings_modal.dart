import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:simply_qibla/helpers/shared_preferences_helper.dart';
import 'package:simply_qibla/l10n/app_localizations.dart';
import 'package:simply_qibla/widgets/about_modal.dart';

Future<void> showSettingsModal(
  BuildContext context,
  String version,
  String buildNumber, {
  VoidCallback? onCompassSettingChanged,
}) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return _SettingsModal(
        version: version,
        buildNumber: buildNumber,
        onCompassSettingChanged: onCompassSettingChanged,
      );
    },
  );
}

class _SettingsModal extends StatefulWidget {
  const _SettingsModal({
    required this.version,
    required this.buildNumber,
    this.onCompassSettingChanged,
  });

  final String version;
  final String buildNumber;
  final VoidCallback? onCompassSettingChanged;

  @override
  State<_SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends State<_SettingsModal> {
  bool _compassEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    bool compassEnabled = await getCompassEnabled();
    setState(() {
      _compassEnabled = compassEnabled;
      _isLoading = false;
    });
  }

  Future<void> _onCompassToggleChanged(bool value) async {
    setState(() {
      _compassEnabled = value;
    });
    await setCompassEnabled(value);
    widget.onCompassSettingChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.settingsTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.settingsCompassToggle),
            value: _compassEnabled,
            onChanged: _isLoading ? null : _onCompassToggleChanged,
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(TablerIcons.info_circle),
            title: Text(AppLocalizations.of(context)!.aboutButtonText),
            trailing: const Icon(TablerIcons.chevron_right),
            contentPadding: EdgeInsets.zero,
            onTap: () {
              Navigator.of(context).pop();
              showAboutModal(context, widget.version, widget.buildNumber);
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.doneText),
        ),
      ],
    );
  }
}
