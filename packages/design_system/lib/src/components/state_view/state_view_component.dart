import 'package:flutter/material.dart';

import '../../theme/app_semantic_colors.dart';
import '../../tokens/app_spacing.dart';
import '../buttons/button_factory.dart';
import '../buttons/button_view_model.dart';
import 'state_view_view_model.dart';

/// Base abstrata: centraliza o conteúdo com margem; cada estado decide o
/// que mostrar em [content].
abstract class StateViewComponent extends StatelessWidget {
  const StateViewComponent({required this.viewModel, super.key});

  final StateViewViewModel viewModel;

  Widget content(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: content(context),
      ),
    );
  }

  /// Ícone + mensagem, usados por vazio e erro.
  Widget iconAndMessage(BuildContext context, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 40, color: color),
        const SizedBox(height: AppSpacing.md),
        Text(
          viewModel.message ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class LoadingStateComponent extends StateViewComponent {
  const LoadingStateComponent({required super.viewModel, super.key});

  @override
  Widget content(BuildContext context) {
    return Semantics(
      label: 'Carregando',
      child: const CircularProgressIndicator(),
    );
  }
}

class EmptyStateComponent extends StateViewComponent {
  const EmptyStateComponent({required super.viewModel, super.key});

  @override
  Widget content(BuildContext context) => iconAndMessage(
    context,
    Icons.inbox_outlined,
    context.semanticColors.muted,
  );
}

class ErrorStateComponent extends StateViewComponent {
  const ErrorStateComponent({required super.viewModel, super.key});

  @override
  Widget content(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconAndMessage(
          context,
          Icons.cloud_off_outlined,
          Theme.of(context).colorScheme.error,
        ),
        if (viewModel.hasAction) ...[
          const SizedBox(height: AppSpacing.lg),
          ButtonFactory.create(
            ButtonViewModel(
              type: ButtonType.secondary,
              label: viewModel.actionLabel,
              icon: Icons.refresh,
              onPressed: viewModel.onAction,
            ),
          ),
        ],
      ],
    );
  }
}
