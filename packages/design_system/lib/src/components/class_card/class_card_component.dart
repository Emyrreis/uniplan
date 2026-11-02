import 'package:flutter/material.dart';

import '../../theme/app_semantic_colors.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';
import 'class_card_view_model.dart';

class ClassCardComponent extends StatelessWidget {
  const ClassCardComponent({required this.viewModel, super.key});

  final ClassCardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final dot = semantic.tone(viewModel.tone).background;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: AppRadius.lgAll,
      child: InkWell(
        borderRadius: AppRadius.lgAll,
        onTap: viewModel.onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md + AppSpacing.xxs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                viewModel.subject,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                viewModel.details,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: semantic.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
