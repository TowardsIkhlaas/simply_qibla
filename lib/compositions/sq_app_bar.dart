import 'package:flutter/material.dart';
import 'package:simply_qibla/widgets/sq_app_bar_title.dart';

class SQAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SQAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const SQAppBarTitle(),
          titleSpacing: 20.0,
        ),
    );
  }
}