import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class SQAppBarTitle extends StatelessWidget {
  const SQAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Icon(
            TablerIcons.building_mosque,
            size: 32.0,
            color: Colors.white,
          ),
        ),
        Text(
          'SimplyQibla',
          style: GoogleFonts.inter(
            textStyle: Theme.of(context).textTheme.titleLarge,
          ),
        )
      ],
    );
  }
}