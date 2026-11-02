import 'package:flutter/material.dart';

import '../../theme/app_semantic_colors.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';
import 'badge_view_model.dart';

class BadgeComponent extends StatelessWidget {
  const BadgeComponent({required this.viewModel, super.key});

  final BadgeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final tone = context.semanticColors.tone(viewModel.tone);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + AppSpacing.xxs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        viewModel.label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: tone.foreground),
      ),
    );
  }
}
