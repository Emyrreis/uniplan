import 'package:flutter/widgets.dart';

import '../../tokens/app_tone.dart';

/// Linha com ícone, texto e switch ("Tema escuro", "Lembretes").
///
/// A mudança é delegada para [onChanged]; o valor vem de [value].
class ToggleViewModel {
  const ToggleViewModel({
    required this.label,
    required this.value,
    this.icon,
    this.tone = AppTone.accent,
    this.enabled = true,
    this.onChanged,
  });

  final String label;
  final bool value;
  final IconData? icon;

  /// Cor do quadrado do ícone.
  final AppTone tone;
  final bool enabled;
  final ValueChanged<bool>? onChanged;

  ValueChanged<bool>? get action => enabled ? onChanged : null;

  /// Tocar em qualquer lugar da linha também alterna.
  VoidCallback? get onRowTap =>
      action == null ? null : () => action!(!value);
}
