import 'package:flutter/widgets.dart';

/// Estilos de botão. A [ButtonFactory] lê o tipo e decide qual componente
/// criar.
enum ButtonType {
  /// Pílula violeta: a ação principal da tela ("Entrar", "Salvar").
  primary,

  /// Pílula lavanda: ação secundária ("Cancelar", "Sair da conta").
  secondary,

  /// Pílula laranja: ação de destaque pontual ("+1 falta").
  accent,

  /// Só texto: links como "Ver todas" e "Esqueci minha senha".
  text,

  /// Botão redondo só com ícone (voltar, editar, notificações).
  icon,
}

/// Dados e estado de um botão.
///
/// O clique é **delegado**: o botão não sabe o que acontece quando é
/// tocado, só chama [onPressed], que vem da ViewModel da tela.
class ButtonViewModel {
  const ButtonViewModel({
    required this.type,
    this.label = '',
    this.icon,
    this.enabled = true,
    this.loading = false,
    this.expanded = false,
    this.compact = false,
    this.semanticLabel,
    this.onPressed,
  });

  final ButtonType type;
  final String label;
  final IconData? icon;
  final bool enabled;

  /// Mostra um indicador de carregamento e bloqueia novos cliques.
  final bool loading;

  /// Ocupa toda a largura disponível (formulários).
  final bool expanded;

  /// Versão baixa (32px), para usar dentro de cards.
  final bool compact;

  /// Texto lido pelo leitor de tela. Obrigatório no tipo [ButtonType.icon].
  final String? semanticLabel;

  final VoidCallback? onPressed;

  /// O que o widget recebe de fato: nulo enquanto desabilitado ou
  /// carregando, o que deixa o botão inativo sem lógica no `build()`.
  VoidCallback? get action => enabled && !loading ? onPressed : null;

  double get height => compact ? 32 : 46;

  ButtonViewModel copyWith({
    String? label,
    bool? enabled,
    bool? loading,
    VoidCallback? onPressed,
  }) {
    return ButtonViewModel(
      type: type,
      label: label ?? this.label,
      icon: icon,
      enabled: enabled ?? this.enabled,
      loading: loading ?? this.loading,
      expanded: expanded,
      compact: compact,
      semanticLabel: semanticLabel,
      onPressed: onPressed ?? this.onPressed,
    );
  }
}
