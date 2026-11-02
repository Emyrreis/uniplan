import 'package:flutter/material.dart';

import '../../theme/app_semantic_colors.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';
import '../badge/badge_factory.dart';
import '../progress_bar/progress_bar_factory.dart';
import 'subject_card_view_model.dart';

class SubjectCardComponent extends StatelessWidget {
  const SubjectCardComponent({required this.viewModel, super.key});

  final SubjectCardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final tone = semantic.tone(viewModel.tone);
    final professor = viewModel.professor;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: AppRadius.lgAll,
      child: InkWell(
        borderRadius: AppRadius.lgAll,
        onTap: viewModel.onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tone.background,
                      borderRadius: AppRadius.mdAll,
                    ),
                    child: Text(
                      viewModel.initials,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: tone.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(viewModel.name, style: theme.textTheme.titleMedium),
                        if (professor != null)
                          Text(
                            professor,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: semantic.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        viewModel.averageLabel,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      BadgeFactory.create(viewModel.status),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ProgressBarFactory.create(viewModel.absenceBar),
            ],
          ),
        ),
      ),
    );
  }
}
