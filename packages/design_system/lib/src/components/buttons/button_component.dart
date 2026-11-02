import 'package:flutter/material.dart';

import '../../theme/app_semantic_colors.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_tone.dart';
import '../../tokens/app_typography.dart';
import 'button_view_model.dart';

/// Base abstrata de todos os botões: não pode ser instanciada direto.
///
/// Guarda a [ButtonViewModel] e o conteúdo comum (texto, ícone ou
/// carregando). Cada subclasse concreta só decide qual widget do Flutter
/// usar e com quais cores.
abstract class ButtonComponent extends StatelessWidget {
  const ButtonComponent({required this.viewModel, super.key});

  final ButtonViewModel viewModel;

  /// Texto com ícone opcional, ou um indicador quando está carregando.
  Widget content(Color color) {
    if (viewModel.loading) {
      return SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(strokeWidth: 2.2, color: color),
      );
    }
    final icon = viewModel.icon;
    if (icon == null) return Text(viewModel.label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Flexible(child: Text(viewModel.label, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  /// Aplica largura total e a altura da ViewModel.
  Widget sized(Widget button) {
    return SizedBox(
      width: viewModel.expanded ? double.infinity : null,
      height: viewModel.height,
      child: button,
    );
  }
}

/// [ButtonType.primary]: usa o `filledButtonTheme` do tema.
class PrimaryButtonComponent extends ButtonComponent {
  const PrimaryButtonComponent({required super.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimary;
    return sized(
      FilledButton(onPressed: viewModel.action, child: content(color)),
    );
  }
}

/// [ButtonType.secondary]: pílula lavanda.
class SecondaryButtonComponent extends ButtonComponent {
  const SecondaryButtonComponent({required super.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    final tone = context.semanticColors.tone(AppTone.neutral);
    return sized(
      FilledButton(
        onPressed: viewModel.action,
        style: FilledButton.styleFrom(
          backgroundColor: tone.background,
          foregroundColor: tone.foreground,
        ),
        child: content(tone.foreground),
      ),
    );
  }
}

/// [ButtonType.accent]: pílula laranja.
class AccentButtonComponent extends ButtonComponent {
  const AccentButtonComponent({required super.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    final tone = context.semanticColors.tone(AppTone.accent);
    return sized(
      FilledButton(
        onPressed: viewModel.action,
        style: FilledButton.styleFrom(
          backgroundColor: tone.background,
          foregroundColor: tone.foreground,
          minimumSize: Size(64, viewModel.height),
          textStyle: viewModel.compact
              ? AppTypography.labelMedium
              : AppTypography.labelLarge,
        ),
        child: content(tone.foreground),
      ),
    );
  }
}

/// [ButtonType.text]: link de texto.
class TextLinkButtonComponent extends ButtonComponent {
  const TextLinkButtonComponent({required super.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return TextButton(onPressed: viewModel.action, child: content(color));
  }
}

/// [ButtonType.icon]: círculo de 44px com um ícone.
class IconCircleButtonComponent extends ButtonComponent {
  const IconCircleButtonComponent({required super.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: viewModel.semanticLabel,
      onPressed: viewModel.action,
      icon: Icon(viewModel.icon),
    );
  }
}
