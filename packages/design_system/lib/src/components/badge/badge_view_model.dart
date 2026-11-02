import '../../tokens/app_tone.dart';

/// Etiqueta em pílula ("Aprovada", "Em risco", "Amanhã", "Prova").
class BadgeViewModel {
  const BadgeViewModel({required this.label, this.tone = AppTone.neutral});

  final String label;
  final AppTone tone;
}
