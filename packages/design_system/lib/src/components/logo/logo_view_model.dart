/// Formatos da logo. A [LogoFactory] decide o componente pelo tipo.
enum LogoType {
  /// Só o símbolo: o "U" com o ponto laranja dentro do quadrado arredondado.
  mark,

  /// Símbolo + nome "UniPlan" (+ frase opcional). Usado no Login e no Cadastro.
  full,
}

/// Dados da logo do UniPlan.
class LogoViewModel {
  const LogoViewModel({
    this.type = LogoType.mark,
    this.size = 64,
    this.onHeader = false,
    this.tagline,
  });

  final LogoType type;

  /// Lado do símbolo, em pixels lógicos.
  final double size;

  /// Em cima da faixa colorida do topo: quadrado branco com "U" violeta.
  /// Fora dela: quadrado violeta com "U" branco.
  final bool onHeader;

  /// Frase abaixo do nome (só no tipo [LogoType.full]).
  final String? tagline;

  String get name => 'UniPlan';

  String get semanticLabel => 'Logo do $name';

  /// O nome cresce junto com o símbolo.
  double get nameFontSize => size * 0.44;
}
