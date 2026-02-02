import 'dart:io';

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
  ValueChanged<String>? onThemeChanged,
  ValueChanged<String>? onColorChanged,
}) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return _SettingsModal(
        version: version,
        buildNumber: buildNumber,
        onCompassSettingChanged: onCompassSettingChanged,
        onThemeChanged: onThemeChanged,
        onColorChanged: onColorChanged,
      );
    },
  );
}

class _SettingsModal extends StatefulWidget {
  const _SettingsModal({
    required this.version,
    required this.buildNumber,
    this.onCompassSettingChanged,
    this.onThemeChanged,
    this.onColorChanged,
  });

  final String version;
  final String buildNumber;
  final VoidCallback? onCompassSettingChanged;
  final ValueChanged<String>? onThemeChanged;
  final ValueChanged<String>? onColorChanged;

  @override
  State<_SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends State<_SettingsModal> {
  bool _compassEnabled = true;
  String _themeMode = 'system';
  String _colorMode = 'default';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    bool compassEnabled = await getCompassEnabled();
    String themeMode = await getThemeMode();
    String colorMode = await getColorMode();
    setState(() {
      _compassEnabled = compassEnabled;
      _themeMode = themeMode;
      _colorMode = colorMode;
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

  Future<void> _onThemeModeChanged(String? value) async {
    if (value == null) return;
    setState(() {
      _themeMode = value;
    });
    await setThemeMode(value);
    widget.onThemeChanged?.call(value);
  }

  Future<void> _onColorModeChanged(String? value) async {
    if (value == null) return;
    setState(() {
      _colorMode = value;
    });
    await setColorMode(value);
    widget.onColorChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool isAndroid = Platform.isAndroid;

    // Build the list of color theme options
    final List<DropdownMenuItem<String>> colorOptions = <DropdownMenuItem<String>>[
      DropdownMenuItem<String>(
        value: 'default',
        child: Text(l10n.colorDefault),
      ),
      if (isAndroid)
        DropdownMenuItem<String>(
          value: 'dynamic',
          child: Text(l10n.colorDynamic),
        ),
      DropdownMenuItem<String>(
        value: 'madinah',
        child: Text(l10n.colorMadinah),
      ),
      DropdownMenuItem<String>(
        value: 'aqsa',
        child: Text(l10n.colorAqsa),
      ),
    ];

    // Ensure the current color mode is valid for the dropdown
    String effectiveColorMode = _colorMode;
    if (!isAndroid && _colorMode == 'dynamic') {
      effectiveColorMode = 'default';
    }

    return AlertDialog(
      title: Text(l10n.settingsTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SwitchListTile(
            title: Text(l10n.settingsCompassToggle),
            value: _compassEnabled,
            onChanged: _isLoading ? null : _onCompassToggleChanged,
            contentPadding: EdgeInsets.zero,
          ),
          ListTile(
            title: Text(l10n.settingsThemeLabel),
            contentPadding: EdgeInsets.zero,
            trailing: DropdownButton<String>(
              value: _themeMode,
              onChanged: _isLoading ? null : _onThemeModeChanged,
              underline: const SizedBox.shrink(),
              style: Theme.of(context).textTheme.bodyMedium,
              items: <DropdownMenuItem<String>>[
                DropdownMenuItem<String>(
                  value: 'system',
                  child: Text(l10n.themeSystem),
                ),
                DropdownMenuItem<String>(
                  value: 'light',
                  child: Text(l10n.themeLight),
                ),
                DropdownMenuItem<String>(
                  value: 'dark',
                  child: Text(l10n.themeDark),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(l10n.settingsColorLabel),
            contentPadding: EdgeInsets.zero,
            trailing: DropdownButton<String>(
              value: effectiveColorMode,
              onChanged: _isLoading ? null : _onColorModeChanged,
              underline: const SizedBox.shrink(),
              style: Theme.of(context).textTheme.bodyMedium,
              items: colorOptions,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(TablerIcons.info_circle),
            title: Text(l10n.aboutButtonText),
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
          child: Text(l10n.doneText),
        ),
      ],
    );
  }
}
