import 'package:flutter/material.dart';

import '../../theme/app_semantic_colors.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';
import '../buttons/button_factory.dart';
import '../buttons/button_view_model.dart';
import '../nav_bar/nav_bar_factory.dart';
import 'sheet_scaffold_view_model.dart';

/// Faixa colorida + folha arredondada.
///
/// Recebe dois "espaços" de conteúdo: [header] (opcional, fica na faixa,
/// abaixo do título) e [body] (dentro da folha).
class SheetScaffoldComponent extends StatelessWidget {
  const SheetScaffoldComponent({
    required this.viewModel,
    required this.body,
    this.header,
    super.key,
  });

  final SheetScaffoldViewModel viewModel;
  final Widget? header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final navBar = viewModel.navBar;
    final fab = viewModel.floatingAction;

    return Scaffold(
      backgroundColor: semantic.header,
      floatingActionButton: fab == null
          ? null
          : FloatingActionButton(
              tooltip: fab.semanticLabel,
              onPressed: fab.action,
              child: Icon(fab.icon),
            ),
      bottomNavigationBar: navBar == null ? null : NavBarFactory.create(navBar),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: _Header(viewModel: viewModel, header: header),
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: AppRadius.sheetTop,
              ),
              child: ClipRRect(borderRadius: AppRadius.sheetTop, child: body),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.viewModel, this.header});

  final SheetScaffoldViewModel viewModel;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final textTheme = Theme.of(context).textTheme;
    final subtitle = viewModel.subtitle;
    final extra = header;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _slot(viewModel.leading),
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  viewModel.title,
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge?.copyWith(
                    color: semantic.onHeader,
                  ),
                ),
              ),
            ),
            _slot(viewModel.trailing),
          ],
        ),
        if (subtitle != null)
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: semantic.onHeader),
          ),
        if (extra != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: extra,
          ),
        ],
      ],
    );
  }

  /// Botão do topo, ou um espaço do mesmo tamanho para o título ficar
  /// centralizado.
  Widget _slot(ButtonViewModel? button) {
    if (button == null) {
      return const SizedBox.square(dimension: AppSpacing.touch);
    }
    return ButtonFactory.create(button);
  }
}
