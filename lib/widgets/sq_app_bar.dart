import 'package:flutter/material.dart';
import 'package:simply_qibla/styles/style.dart';
import 'package:simply_qibla/widgets/info_button.dart';
import 'package:simply_qibla/widgets/sq_app_bar_title.dart';

class SQAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SQAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarPreferredSize);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppPadding.appBarTop),
      child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const SQAppBarTitle(),
          titleSpacing: AppPadding.standard,
          actions: const <Widget>[
            Padding(
              padding: EdgeInsets.only(right: AppPadding.appBarActionRight),
              child: InfoButton(),
            )
          ],
        ),
    );
  }
}
