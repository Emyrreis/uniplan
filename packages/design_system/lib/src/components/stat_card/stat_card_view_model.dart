import '../buttons/button_view_model.dart';

/// Onde o número aparece. A [StatCardFactory] decide o componente pelo tipo.
enum StatCardType {
  /// Direto sobre a faixa colorida do topo, sem fundo (Home: "Média geral").
  onHeader,

  /// Card claro (detalhe da disciplina: "Média atual", "Faltas").
  card,
}

/// Um número de destaque com rótulo e legenda.
class StatCardViewModel {
  const StatCardViewModel({
    required this.type,
    required this.label,
    required this.value,
    this.suffix,
    this.caption,
    this.highlight = false,
    this.action,
  });

  final StatCardType type;
  final String label;

  /// O número em si: "8,2", "2".
  final String value;

  /// Complemento menor ao lado do número: "/ 18", "entregas".
  final String? suffix;
  final String? caption;

  /// Pinta o número com a cor de destaque (ex.: pendências).
  final bool highlight;

  /// Botão opcional dentro do card ("+1 falta").
  final ButtonViewModel? action;
}
