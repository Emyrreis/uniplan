import 'package:flutter/foundation.dart';

import '../../tokens/app_tone.dart';

/// Foto do usuário ou, sem foto, as iniciais num círculo colorido.
class AvatarViewModel {
  const AvatarViewModel({
    required this.name,
    this.imageUrl,
    this.size = 48,
    this.tone = AppTone.accent,
    this.onEdit,
  });

  final String name;
  final String? imageUrl;
  final double size;
  final AppTone tone;

  /// Quando informado, o avatar vira um botão com o selo de câmera
  /// (tela Editar perfil). O toque é delegado para a tela, que abre as
  /// opções "Escolher da galeria", "Tirar foto" e "Remover foto".
  final VoidCallback? onEdit;

  bool get editable => onEdit != null;

  /// Tamanho do selo de câmera, proporcional ao avatar.
  double get badgeSize => size * 0.34;

  bool get hasImage => imageUrl != null && imageUrl!.trim().isNotEmpty;

  /// "Emilly Reis" → "ER"; "Emilly" → "E".
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  double get fontSize => size * 0.36;
}
