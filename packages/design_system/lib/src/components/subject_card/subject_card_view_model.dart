import 'package:flutter/foundation.dart';

import '../../tokens/app_tone.dart';
import '../badge/badge_view_model.dart';
import '../progress_bar/progress_bar_view_model.dart';

/// Card de uma disciplina na lista: sigla colorida, nome, professor,
/// média, situação e barra de faltas.
class SubjectCardViewModel {
  const SubjectCardViewModel({
    required this.name,
    required this.initials,
    required this.tone,
    required this.averageLabel,
    required this.status,
    required this.absences,
    required this.maxAbsences,
    this.professor,
    this.onTap,
  });

  final String name;

  /// Sigla no quadrado colorido: "M2", "IA".
  final String initials;

  /// Cor da disciplina.
  final AppTone tone;
  final String? professor;

  /// Média já formatada pela tela: "9,1" ou "–" sem notas.
  final String averageLabel;
  final BadgeViewModel status;
  final int absences;
  final int maxAbsences;
  final VoidCallback? onTap;

  /// Fração de faltas usadas, de 0 a 1.
  double get absenceShare =>
      maxAbsences <= 0 ? 0.0 : (absences / maxAbsences).clamp(0.0, 1.0).toDouble();

  /// A partir de 75% das faltas a barra fica no tom de aviso.
  bool get absenceAtRisk => absenceShare >= 0.75;

  /// A barra de faltas, montada aqui para o componente só repassar.
  ProgressBarViewModel get absenceBar => ProgressBarViewModel(
    type: ProgressBarType.thin,
    value: absenceShare,
    tone: absenceAtRisk ? AppTone.warning : AppTone.primary,
    caption: 'Faltas $absences de $maxAbsences',
  );
}
