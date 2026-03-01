import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:simply_qibla/l10n/app_localizations.dart';
import 'package:simply_qibla/styles/style.dart';

class SQAppBarTitle extends StatelessWidget {
  const SQAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final Color iconColor =
        Theme.of(context).appBarTheme.iconTheme?.color ?? Colors.white;
    final Color textColor =
        Theme.of(context).appBarTheme.titleTextStyle?.color ?? Colors.white;

    return Row(
      children: <Widget>[
        Icon(
          TablerIcons.location,
          size: AppDimensions.iconSizeLg,
          color: iconColor,
        ),
        Text(
          AppLocalizations.of(context)!.appNamePascalCase,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: textColor,
              ),
        )
      ],
    );
  }
}
