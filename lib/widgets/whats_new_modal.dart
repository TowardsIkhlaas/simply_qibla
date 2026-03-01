import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:simply_qibla/data/release_notes.dart';
import 'package:simply_qibla/l10n/app_localizations.dart';
import 'package:simply_qibla/styles/style.dart';

Future<void> showWhatsNewModal(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.borderRadiusXl),
      ),
    ),
    builder: (BuildContext context) {
      return const _WhatsNewModal();
    },
  );
}

class _WhatsNewModal extends StatelessWidget {
  const _WhatsNewModal();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.standard),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildDragHandle(theme),
            const SizedBox(height: AppPadding.standard),
            _buildHeader(l10n, theme),
            const SizedBox(height: AppPadding.standard),
            if (currentRelease.hasFeatures)
              _buildSection(
                context: context,
                title: l10n.whatsNewNewFeatures,
                icon: TablerIcons.sparkles,
                items: currentRelease.features,
                l10n: l10n,
              ),
            if (currentRelease.hasImprovements)
              _buildSection(
                context: context,
                title: l10n.whatsNewImprovements,
                icon: TablerIcons.trending_up,
                items: currentRelease.improvements,
                l10n: l10n,
              ),
            if (currentRelease.hasFixes)
              _buildSection(
                context: context,
                title: l10n.whatsNewBugFixes,
                icon: TablerIcons.bug,
                items: currentRelease.fixes,
                l10n: l10n,
              ),
            const SizedBox(height: AppPadding.standard),
            _buildDismissButton(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle(ThemeData theme) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, ThemeData theme) {
    return Column(
      children: <Widget>[
        Text(
          l10n.whatsNewTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppPadding.standard / 2),
        SizedBox(
          width: AppDimensions.lineWidth,
          height: AppPadding.paddingMd,
          child: CustomPaint(
            painter: _SquigglyLinePainter(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<String> items,
    required AppLocalizations l10n,
  }) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.standard / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                icon,
                size: AppDimensions.iconSizeSm,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map((String key) => _buildItem(
                context: context,
                text: currentRelease.resolveKey(key, l10n),
              )),
        ],
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: AppPadding.standard, bottom: AppPadding.paddingXxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('\u2022 '),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(l10n.whatsNewGotIt),
      ),
    );
  }
}

class _SquigglyLinePainter extends CustomPainter {
  _SquigglyLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path();
    const double waveHeight = 3.5;
    const double waveLength = 32.0;

    path.moveTo(0, size.height / 2);

    for (double x = 0; x <= size.width; x += 1) {
      final double y =
          size.height / 2 + sin((x / waveLength) * 2 * pi) * waveHeight;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
