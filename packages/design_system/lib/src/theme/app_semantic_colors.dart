import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_tone.dart';

/// Par de cores de um tom: fundo e o texto/ícone que vai em cima dele.
typedef ToneColors = ({Color background, Color foreground});

/// Cores com significado que não têm lugar no [ColorScheme]: destaque,
/// sucesso, aviso, texto secundário, faixa do topo.
///
/// Registrada como [ThemeExtension]; os componentes leem com
/// `context.semanticColors`.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({required this.palette});

  final AppColorPalette palette;

  Color get muted => palette.onSurfaceMuted;
  Color get header => palette.header;
  Color get onHeader => palette.onHeader;
  Color get track => palette.track;

  /// Resolve um [AppTone] nas cores do tema atual.
  ToneColors tone(AppTone tone) => switch (tone) {
    AppTone.primary => (
      background: palette.primary,
      foreground: palette.onPrimary,
    ),
    AppTone.accent => (
      background: palette.accent,
      foreground: palette.onAccent,
    ),
    AppTone.success => (
      background: palette.success,
      foreground: palette.onSuccess,
    ),
    AppTone.warning => (
      background: palette.warning,
      foreground: palette.onWarning,
    ),
    AppTone.neutral => (
      background: palette.primaryContainer,
      foreground: palette.onPrimaryContainer,
    ),
    AppTone.ink => (
      background: palette.onSurface,
      foreground: palette.background,
    ),
  };

  @override
  AppSemanticColors copyWith({AppColorPalette? palette}) =>
      AppSemanticColors(palette: palette ?? this.palette);

  /// A troca de tema é instantânea, então não interpola as cores.
  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) =>
      t < 0.5 || other == null ? this : other;
}

/// Atalho: `context.semanticColors.tone(AppTone.accent)`.
extension SemanticColorsContext on BuildContext {
  AppSemanticColors get semanticColors {
    final colors = Theme.of(this).extension<AppSemanticColors>();
    assert(
      colors != null,
      'AppSemanticColors não encontrado. Use AppTheme.light() ou AppTheme.dark().',
    );
    return colors!;
  }
}
