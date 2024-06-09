import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:simply_qibla/constants/constants.dart';
import 'package:simply_qibla/styles/style.dart';

class SQAppBarTitle extends StatelessWidget {
  const SQAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(
          TablerIcons.location,
          size: AppDimensions.iconSizeLg,
          color: Colors.white,
        ),
        Text(
          AppStrings.appNamePascalCase,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
              ),
        )
      ],
    );
  }
}
