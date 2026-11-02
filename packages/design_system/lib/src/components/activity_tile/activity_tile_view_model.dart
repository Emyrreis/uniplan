import 'package:flutter/material.dart';

import '../../tokens/app_tone.dart';
import '../badge/badge_view_model.dart';
import '../checkbox/checkbox_view_model.dart';

/// Tipo de atividade acadêmica. Cada um tem ícone, cor e nome próprios.
enum ActivityKind {
  exam('Prova', Icons.edit_note, AppTone.accent),
  assignment('Trabalho', Icons.description_outlined, AppTone.primary),
  exercise('Lista', Icons.checklist, AppTone.success),
  presentation('Seminário', Icons.co_present_outlined, AppTone.warning);

  const ActivityKind(this.label, this.icon, this.tone);

  final String label;
  final IconData icon;
  final AppTone tone;
}

/// Variações do tile. A [ActivityTileFactory] decide o componente pelo tipo.
enum ActivityTileType {
  /// Ícone do tipo + prazo à direita (Home: "Próximas entregas").
  due,

  /// Ícone do tipo + nota à direita (detalhe da disciplina).
  grade,

  /// Caixa de marcar "entregue" + tipo à direita (aba Atividades).
  check,
}

/// Uma linha de atividade.
class ActivityTileViewModel {
  const ActivityTileViewModel({
    required this.type,
    required this.kind,
    required this.title,
    this.subtitle,
    this.dueLabel,
    this.dueSoon = false,
    this.gradeLabel,
    this.checked = false,
    this.onCheckedChanged,
    this.onTap,
  });

  final ActivityTileType type;
  final ActivityKind kind;
  final String title;

  /// "Mobile II · 23:59".
  final String? subtitle;

  /// Prazo já formatado: "Amanhã", "Em 5 dias", "12/11".
  final String? dueLabel;

  /// Prazo em até 2 dias: o badge fica laranja.
  final bool dueSoon;

  /// Nota já formatada; nulo = ainda sem nota ("Pendente").
  final String? gradeLabel;

  final bool checked;

  /// Marcar/desmarcar é delegado para a tela.
  final ValueChanged<bool>? onCheckedChanged;
  final VoidCallback? onTap;

  BadgeViewModel get dueBadge => BadgeViewModel(
    label: dueLabel ?? '',
    tone: dueSoon ? AppTone.accent : AppTone.neutral,
  );

  BadgeViewModel get kindBadge =>
      BadgeViewModel(label: kind.label, tone: kind.tone);

  bool get hasGrade => gradeLabel != null;

  String get gradeText => gradeLabel ?? 'Pendente';

  CheckboxViewModel get checkbox => CheckboxViewModel(
    checked: checked,
    semanticLabel: 'Marcar "$title" como entregue',
    onChanged: onCheckedChanged,
  );
}
