import 'package:flutter/foundation.dart';

/// Caixa de marcar ("entregue"), com texto opcional ao lado.
///
/// A mudança é delegada para [onChanged]; o valor vem de [checked].
class CheckboxViewModel {
  const CheckboxViewModel({
    required this.checked,
    this.label,
    this.enabled = true,
    this.semanticLabel,
    this.onChanged,
  });

  final bool checked;
  final String? label;
  final bool enabled;

  /// Lido pelo leitor de tela quando não há [label].
  final String? semanticLabel;
  final ValueChanged<bool>? onChanged;

  VoidCallback? get onTap =>
      enabled && onChanged != null ? () => onChanged!(!checked) : null;
}
