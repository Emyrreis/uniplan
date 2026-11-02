import 'package:flutter/foundation.dart';

import '../../tokens/app_tone.dart';

/// Uma aula na grade da semana: horário, disciplina e onde ela acontece
/// (bloco, sala e andar). Usado na tela "Onde é minha aula?".
class ScheduleTileViewModel {
  const ScheduleTileViewModel({
    required this.subject,
    required this.start,
    required this.end,
    required this.block,
    required this.room,
    this.professor,
    this.floor,
    this.tone = AppTone.primary,
    this.onTap,
  });

  final String subject;

  /// Horários já formatados: "19:00", "20:40".
  final String start;
  final String end;

  /// Só o identificador do bloco ("C"); o rótulo "Bloco C" sai de [blockLabel].
  final String block;
  final String room;
  final String? professor;

  /// "Térreo", "2º andar".
  final String? floor;

  /// Cor da disciplina (faixa ao lado do horário).
  final AppTone tone;
  final VoidCallback? onTap;

  String get blockLabel => 'Bloco $block';

  /// Texto lido pelo leitor de tela, numa frase.
  String get semanticLabel => [
    '$subject, das $start às $end',
    blockLabel,
    room,
    ?floor,
  ].join(', ');

  /// A busca da tela procura por disciplina, bloco ou sala.
  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return '$subject $blockLabel $room'.toLowerCase().contains(q);
  }
}
