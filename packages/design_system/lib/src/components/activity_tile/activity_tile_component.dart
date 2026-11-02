import 'package:flutter/material.dart';

import '../../theme/app_semantic_colors.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';
import '../badge/badge_factory.dart';
import '../checkbox/checkbox_factory.dart';
import 'activity_tile_view_model.dart';

/// Base abstrata dos tiles de atividade.
///
/// Monta a linha (início, título/subtítulo, fim). Cada subclasse concreta
/// diz só o que vai no [leading] e no [trailing].
abstract class ActivityTileComponent extends StatelessWidget {
  const ActivityTileComponent({required this.viewModel, super.key});

  final ActivityTileViewModel viewModel;

  Widget leading(BuildContext context);

  Widget trailing(BuildContext context);

  /// Quadrado colorido com o ícone do tipo de atividade.
  Widget kindIcon(BuildContext context) {
    final tone = context.semanticColors.tone(viewModel.kind.tone);
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: AppRadius.mdAll,
      ),
      child: Icon(viewModel.kind.icon, color: tone.foreground, size: 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = viewModel.subtitle;

    return InkWell(
      borderRadius: AppRadius.mdAll,
      onTap: viewModel.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs + 2),
        child: Row(
          children: [
            leading(context),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    viewModel.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.semanticColors.muted,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            trailing(context),
          ],
        ),
      ),
    );
  }
}

/// [ActivityTileType.due]: ícone do tipo + badge de prazo.
class DueActivityTileComponent extends ActivityTileComponent {
  const DueActivityTileComponent({required super.viewModel, super.key});

  @override
  Widget leading(BuildContext context) => kindIcon(context);

  @override
  Widget trailing(BuildContext context) =>
      BadgeFactory.create(viewModel.dueBadge);
}

/// [ActivityTileType.grade]: ícone do tipo + nota (ou "Pendente").
class GradeActivityTileComponent extends ActivityTileComponent {
  const GradeActivityTileComponent({required super.viewModel, super.key});

  @override
  Widget leading(BuildContext context) => kindIcon(context);

  @override
  Widget trailing(BuildContext context) {
    final theme = Theme.of(context);
    final color = viewModel.hasGrade
        ? theme.colorScheme.onSurface
        : theme.colorScheme.primary;
    return Text(
      viewModel.gradeText,
      style: theme.textTheme.titleMedium?.copyWith(color: color),
    );
  }
}

/// [ActivityTileType.check]: caixa "entregue" + badge com o tipo.
class CheckActivityTileComponent extends ActivityTileComponent {
  const CheckActivityTileComponent({required super.viewModel, super.key});

  @override
  Widget leading(BuildContext context) =>
      CheckboxFactory.create(viewModel.checkbox);

  @override
  Widget trailing(BuildContext context) =>
      BadgeFactory.create(viewModel.kindBadge);
}
