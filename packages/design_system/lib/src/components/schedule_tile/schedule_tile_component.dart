import 'package:flutter/material.dart';

import '../../theme/app_semantic_colors.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_tone.dart';
import 'schedule_tile_view_model.dart';

/// Card da aula: horário à esquerda com a faixa da cor da disciplina e,
/// à direita, a disciplina com as pílulas de bloco e sala.
class ScheduleTileComponent extends StatelessWidget {
  const ScheduleTileComponent({required this.viewModel, super.key});

  final ScheduleTileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final stripe = semantic.tone(viewModel.tone).background;
    final professor = viewModel.professor;
    final floor = viewModel.floor;

    return Semantics(
      label: viewModel.semanticLabel,
      excludeSemantics: true,
      button: viewModel.onTap != null,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.lgAll,
        child: InkWell(
          borderRadius: AppRadius.lgAll,
          onTap: viewModel.onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md + AppSpacing.xxs),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 52,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.start,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          viewModel.end,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: semantic.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 3,
                    margin: const EdgeInsets.only(right: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: stripe,
                      borderRadius: AppRadius.pillAll,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(viewModel.subject, style: theme.textTheme.titleMedium),
                        if (professor != null)
                          Text(
                            professor,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: semantic.muted,
                            ),
                          ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.xs,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _Pill(
                              icon: Icons.apartment,
                              label: viewModel.blockLabel,
                              tone: AppTone.primary,
                            ),
                            _Pill(
                              icon: Icons.place_outlined,
                              label: viewModel.room,
                              tone: null,
                            ),
                            if (floor != null)
                              Text(
                                floor,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: semantic.muted,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pílula com ícone. Sem tom, usa o fundo da folha (contraste com o card).
class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, required this.tone});

  final IconData icon;
  final String label;
  final AppTone? tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = tone == null
        ? (
            background: theme.scaffoldBackgroundColor,
            foreground: theme.colorScheme.onSurface,
          )
        : context.semanticColors.tone(tone!);

    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.foreground),
          const SizedBox(width: AppSpacing.xs + AppSpacing.xxs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colors.foreground,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
