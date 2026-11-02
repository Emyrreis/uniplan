/// Tons com significado, usados por badges, ícones de atividade e cores de
/// disciplina. Cada componente recebe um tom e o tema resolve a cor
/// (fundo + texto) certa para o claro e o escuro.
enum AppTone {
  /// Violeta.
  primary,

  /// Laranja.
  accent,

  /// Verde-azulado.
  success,

  /// Laranja escuro ("em risco").
  warning,

  /// Lavanda, discreto.
  neutral,

  /// Escuro (no tema escuro, invertido).
  ink,
}
