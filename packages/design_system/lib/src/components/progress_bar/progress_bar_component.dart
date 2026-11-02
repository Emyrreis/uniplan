import 'package:flutter/material.dart';

import '../../theme/app_semantic_colors.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';
import 'progress_bar_view_model.dart';

/// Base abstrata das barras: guarda a ViewModel e o texto de legenda.
abstract class ProgressBarComponent extends StatelessWidget {
  const ProgressBarComponent({required this.viewModel, super.key});

  final ProgressBarViewModel viewModel;

  /// A barra em si; cada formato desenha a sua.
  Widget bar(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final caption = viewModel.caption;
    if (caption == null) return bar(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        bar(context),
        const SizedBox(height: AppSpacing.xs + AppSpacing.xxs),
        Text(caption, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

/// [ProgressBarType.labeled]: feita para ficar sobre a faixa do topo.
class LabeledProgressBarComponent extends ProgressBarComponent {
  const LabeledProgressBarComponent({required super.viewModel, super.key});

  @override
  Widget bar(BuildContext context) {
    final onHeader = context.semanticColors.onHeader;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Progresso',
      value: viewModel.percentLabel,
      child: Container(
        height: 26,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.22),
          borderRadius: AppRadius.pillAll,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: viewModel.share,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.pillAll,
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Text(
                      viewModel.percentLabel,
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.ink,
                      ),
                    ),
                    const Spacer(),
                    if (viewModel.trailingLabel != null)
                      Text(
                        viewModel.trailingLabel!,
                        style: textTheme.labelMedium?.copyWith(
                          color: onHeader,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// [ProgressBarType.thin]: trilha de 8px com preenchimento no tom pedido.
class ThinProgressBarComponent extends ProgressBarComponent {
  const ThinProgressBarComponent({required super.viewModel, super.key});

  @override
  Widget bar(BuildContext context) {
    final tone = context.semanticColors.tone(viewModel.tone);
    return Semantics(
      value: viewModel.percentLabel,
      child: ClipRRect(
        borderRadius: AppRadius.pillAll,
        child: LinearProgressIndicator(
          value: viewModel.share,
          minHeight: 8,
          color: tone.background,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
