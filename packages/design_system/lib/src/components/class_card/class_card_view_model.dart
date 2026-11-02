import 'package:flutter/foundation.dart';

import '../../tokens/app_tone.dart';

/// Card pequeno de uma aula do dia ("Mobile II · 19:00 · Bloco C · Lab 3").
class ClassCardViewModel {
  const ClassCardViewModel({
    required this.subject,
    required this.time,
    this.block,
    this.room,
    this.tone = AppTone.primary,
    this.onTap,
  });

  final String subject;

  /// Horário já formatado: "19:00".
  final String time;

  /// Só o identificador do bloco ("C").
  final String? block;
  final String? room;
  final AppTone tone;
  final VoidCallback? onTap;

  String get details =>
      [time, if (block != null) 'Bloco $block', ?room].join(' · ');
}
