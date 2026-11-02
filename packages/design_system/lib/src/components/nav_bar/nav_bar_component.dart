import 'package:flutter/material.dart';

import '../../tokens/app_durations.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';
import 'nav_bar_view_model.dart';

/// Barra lavanda com cantos superiores arredondados; o item ativo ganha
/// uma pílula violeta.
class NavBarComponent extends StatelessWidget {
  const NavBarComponent({required this.viewModel, super.key});

  final NavBarViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // O fundo de trás pinta os cantos arredondados com a cor da folha.
    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.sheetTop,
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final entry in viewModel.entries) _NavItem(entry: entry),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.entry});

  final NavBarEntry entry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: entry.selected,
      label: entry.label,
      child: Tooltip(
        message: entry.label,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          onTap: entry.onTap,
          child: AnimatedContainer(
            duration: AppDurations.normal,
            width: 60,
            height: 52,
            decoration: BoxDecoration(
              color: entry.selected ? scheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              entry.icon,
              size: 24,
              color: entry.selected ? scheme.onPrimary : scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

/// Espaço que o conteúdo deve deixar livre embaixo quando há barra.
const double navBarHeight = 80 + AppSpacing.lg;
