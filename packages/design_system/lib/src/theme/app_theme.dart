import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';
import 'app_semantic_colors.dart';

/// Monta os dois [ThemeData] do app a partir dos tokens.
///
/// Visual: faixa violeta no topo, folha clara arredondada com o conteúdo,
/// botões em pílula e campos preenchidos sem borda.
abstract final class AppTheme {
  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColorPalette p, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: p.primary,
      onPrimary: p.onPrimary,
      primaryContainer: p.primaryContainer,
      onPrimaryContainer: p.onPrimaryContainer,
      secondary: p.accent,
      onSecondary: p.onAccent,
      tertiary: p.success,
      onTertiary: p.onSuccess,
      surface: p.surface,
      onSurface: p.onSurface,
      surfaceContainerHighest: p.surfaceVariant,
      onSurfaceVariant: p.onSurfaceMuted,
      outline: p.surfaceVariant,
      outlineVariant: p.surfaceVariant,
      error: p.error,
      onError: p.onError,
    );

    final textTheme = AppTypography.textTheme.apply(
      bodyColor: p.onSurface,
      displayColor: p.onSurface,
    );

    const pillShape = RoundedRectangleBorder(
      borderRadius: AppRadius.pillAll,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      // Fonte declarada num pacote: o Flutter a registra com este prefixo.
      fontFamily:
          'packages/${AppTypography.fontPackage}/${AppTypography.fontFamily}',
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      textTheme: textTheme,
      dividerColor: p.surfaceVariant,
      extensions: [AppSemanticColors(palette: p)],
      appBarTheme: AppBarTheme(
        backgroundColor: p.header,
        foregroundColor: p.onHeader,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge.copyWith(color: p.onHeader),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: p.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: p.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: p.error, width: 2),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: p.onSurfaceMuted),
        errorStyle: AppTypography.bodySmall.copyWith(color: p.error),
        prefixIconColor: p.onSurface,
        suffixIconColor: p.onSurface,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(120, 46),
          backgroundColor: p.primary,
          foregroundColor: p.onPrimary,
          disabledBackgroundColor: p.surfaceVariant,
          disabledForegroundColor: p.onSurfaceMuted,
          shape: pillShape,
          textStyle: AppTypography.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(AppSpacing.touch, AppSpacing.touch),
          foregroundColor: p.primary,
          shape: pillShape,
          textStyle: AppTypography.labelMedium,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(AppSpacing.touch, AppSpacing.touch),
          backgroundColor: p.primaryContainer,
          foregroundColor: p.onPrimaryContainer,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.accent,
        foregroundColor: p.onAccent,
        shape: const CircleBorder(),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.surface,
        selectedColor: p.primary,
        disabledColor: p.surfaceVariant,
        side: BorderSide.none,
        shape: pillShape,
        showCheckmark: false,
        labelStyle: AppTypography.labelMedium.copyWith(color: p.onSurface),
        secondaryLabelStyle: AppTypography.labelMedium.copyWith(
          color: p.onPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(p.onPrimary),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? p.primary : p.track,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.primary),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.onSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: p.background,
        ),
        actionTextColor: p.accent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.background,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.background,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
      ),
      dividerTheme: DividerThemeData(
        color: p.surfaceVariant,
        space: 1,
        thickness: 1,
      ),
    );
  }
}
