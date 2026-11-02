import '../../tokens/app_tone.dart';

/// Foto do usuário ou, sem foto, as iniciais num círculo colorido.
class AvatarViewModel {
  const AvatarViewModel({
    required this.name,
    this.imageUrl,
    this.size = 48,
    this.tone = AppTone.accent,
  });

  final String name;
  final String? imageUrl;
  final double size;
  final AppTone tone;

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
