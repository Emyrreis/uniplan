import 'package:flutter/foundation.dart';

/// Estados de uma área que carrega dados. A [StateViewFactory] decide o
/// componente pelo tipo.
enum StateViewType { loading, empty, error }

/// Carregando, vazio ou erro (com "Tentar de novo").
class StateViewViewModel {
  const StateViewViewModel({
    required this.type,
    this.message,
    this.actionLabel = 'Tentar de novo',
    this.onAction,
  });

  const StateViewViewModel.loading() : this(type: StateViewType.loading);

  const StateViewViewModel.empty(String message)
    : this(type: StateViewType.empty, message: message);

  const StateViewViewModel.error(String message, {VoidCallback? onRetry})
    : this(type: StateViewType.error, message: message, onAction: onRetry);

  final StateViewType type;
  final String? message;
  final String actionLabel;

  /// O "tentar de novo" é delegado para a tela.
  final VoidCallback? onAction;

  bool get hasAction => onAction != null;
}
