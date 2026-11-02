import '../../tokens/app_tone.dart';

/// Formatos da barra. A [ProgressBarFactory] decide o componente pelo tipo.
enum ProgressBarType {
  /// Barra alta com a porcentagem dentro (topo da Home: "68% · 16 semanas").
  labeled,

  /// Barra fina de 8px (faltas no card da disciplina).
  thin,
}

/// Dados de uma barra de progresso.
class ProgressBarViewModel {
  const ProgressBarViewModel({
    required this.type,
    required this.value,
    this.trailingLabel,
    this.caption,
    this.tone = AppTone.primary,
  });

  final ProgressBarType type;

  /// De 0 a 1. Valores fora disso são cortados em [share].
  final double value;

  /// Texto à direita, dentro da barra (tipo [ProgressBarType.labeled]).
  final String? trailingLabel;

  /// Texto pequeno abaixo da barra ("Faltas 2 de 18").
  final String? caption;

  /// Cor do preenchimento no tipo [ProgressBarType.thin].
  final AppTone tone;

  double get share => value.clamp(0.0, 1.0).toDouble();

  String get percentLabel => '${(share * 100).round()}%';
}
