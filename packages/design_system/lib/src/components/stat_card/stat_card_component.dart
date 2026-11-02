import 'package:flutter/material.dart';

import '../../theme/app_semantic_colors.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_tone.dart';
import '../buttons/button_factory.dart';
import 'stat_card_view_model.dart';

/// Base abstrata: o bloco rótulo / número / legenda é igual nos dois tipos.
/// As subclasses só escolhem as cores e o "fundo".
abstract class StatCardComponent extends StatelessWidget {
  const StatCardComponent({required this.viewModel, super.key});

  final StatCardViewModel viewModel;

  Widget figures(
    BuildContext context, {
    required Color text,
    required Color muted,
    required Color highlight,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final valueColor = viewModel.highlight ? highlight : text;
    final suffix = viewModel.suffix;
    final caption = viewModel.caption;
    final action = viewModel.action;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(viewModel.label, style: textTheme.bodySmall?.copyWith(color: text)),
        Text.rich(
          TextSpan(
            text: viewModel.value,
            children: [
              if (suffix != null)
                TextSpan(
                  text: ' $suffix',
                  style: textTheme.bodyMedium?.copyWith(color: valueColor),
                ),
            ],
          ),
          style: textTheme.headlineMedium?.copyWith(color: valueColor),
        ),
        if (caption != null)
          Text(caption, style: textTheme.labelSmall?.copyWith(color: muted)),
        if (action != null) ...[
          const SizedBox(height: AppSpacing.xs),
          ButtonFactory.create(action),
        ],
      ],
    );
  }
}

/// [StatCardType.onHeader]: sem fundo, texto claro sobre a faixa.
class HeaderStatCardComponent extends StatCardComponent {
  const HeaderStatCardComponent({required super.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    return figures(
      context,
      text: semantic.onHeader,
      muted: semantic.onHeader.withValues(alpha: 0.8),
      highlight: const Color(0xFFFFD3A8), // laranja claro, legível no violeta
    );
  }
}

/// [StatCardType.card]: card claro com cantos de 20.
class SurfaceStatCardComponent extends StatCardComponent {
  const SurfaceStatCardComponent({required super.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: AppRadius.lgAll,
      ),
      child: figures(
        context,
        text: theme.colorScheme.onSurface,
        muted: semantic.muted,
        highlight: semantic.tone(AppTone.warning).background,
      ),
    );
  }
}
