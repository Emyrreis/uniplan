import 'package:flutter/foundation.dart';

/// Título de seção com link opcional à direita ("Aulas de hoje · Ver todas").
class SectionHeaderViewModel {
  const SectionHeaderViewModel({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;

  /// O toque no link é delegado para a tela.
  final VoidCallback? onAction;

  bool get hasAction => actionLabel != null && onAction != null;
}
