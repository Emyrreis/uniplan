import 'package:flutter/painting.dart';

/// Paleta de cores de um tema (claro ou escuro).
///
/// As duas paletas têm os mesmos campos, então o tema é montado do mesmo
/// jeito a partir de qualquer uma. Os componentes não leem estas cores
/// direto: passam pelo [ThemeData] ou pelo `AppSemanticColors`.
class AppColorPalette {
  const AppColorPalette({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.accent,
    required this.onAccent,
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.error,
    required this.onError,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.header,
    required this.onHeader,
    required this.track,
  });

  /// Violeta: botões principais, item ativo da navegação.
  final Color primary;
  final Color onPrimary;

  /// Lavanda: campos, cards, barra de navegação.
  final Color primaryContainer;
  final Color onPrimaryContainer;

  /// Laranja: prazos próximos, alertas, ação de destaque.
  final Color accent;
  final Color onAccent;

  /// Verde-azulado: terceira cor das disciplinas, "concluído".
  final Color success;
  final Color onSuccess;

  /// Laranja escuro: "em risco" (faltas ou média abaixo do mínimo).
  final Color warning;
  final Color onWarning;

  final Color error;
  final Color onError;

  /// Fundo da folha arredondada onde fica o conteúdo.
  final Color background;
  final Color surface;

  /// Um tom acima de [surface]: trilhas de barras e bordas.
  final Color surfaceVariant;
  final Color onSurface;

  /// Texto secundário.
  final Color onSurfaceMuted;

  /// Faixa colorida do topo das telas.
  final Color header;
  final Color onHeader;

  /// Trilha do switch desligado.
  final Color track;
}

/// As duas paletas oficiais do UniPlan.
abstract final class AppColors {
  /// Tinta escura usada sobre fundos claros fixos (ex.: preenchimento da
  /// barra de progresso do topo), nos dois temas.
  static const Color ink = Color(0xFF1C1B2E);

  static const AppColorPalette light = AppColorPalette(
    primary: Color(0xFF5B4BDB),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFECE9FB),
    onPrimaryContainer: ink,
    accent: Color(0xFFE8762C),
    onAccent: ink,
    success: Color(0xFF1F9E8F),
    onSuccess: Color(0xFFFFFFFF),
    warning: Color(0xFFB4461A),
    onWarning: Color(0xFFFFFFFF),
    error: Color(0xFFC0392B),
    onError: Color(0xFFFFFFFF),
    background: Color(0xFFF6F5FB),
    surface: Color(0xFFECE9FB),
    surfaceVariant: Color(0xFFDCD8F5),
    onSurface: ink,
    onSurfaceMuted: Color(0xFF5E5B78),
    header: Color(0xFF5B4BDB),
    onHeader: Color(0xFFFFFFFF),
    track: Color(0xFFC9C4EA),
  );

  static const AppColorPalette dark = AppColorPalette(
    primary: Color(0xFF8B7CF6),
    onPrimary: Color(0xFF14131F),
    primaryContainer: Color(0xFF2E2A52),
    onPrimaryContainer: Color(0xFFECEAF7),
    accent: Color(0xFFF29A5B),
    onAccent: Color(0xFF14131F),
    success: Color(0xFF3CC2B1),
    onSuccess: Color(0xFF0B1F1C),
    warning: Color(0xFFF08A5D),
    onWarning: Color(0xFF14131F),
    error: Color(0xFFF07A6E),
    onError: Color(0xFF14131F),
    background: Color(0xFF14131F),
    surface: Color(0xFF22203A),
    surfaceVariant: Color(0xFF2E2B4B),
    onSurface: Color(0xFFECEAF7),
    onSurfaceMuted: Color(0xFFA9A5C6),
    header: Color(0xFF2A2360),
    onHeader: Color(0xFFFFFFFF),
    track: Color(0xFF3A3760),
  );
}
