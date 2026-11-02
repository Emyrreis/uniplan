import 'package:flutter/material.dart';

/// Escala tipográfica: Poppins, empacotada neste pacote.
abstract final class AppTypography {
  static const String fontFamily = 'Poppins';
  static const String fontPackage = 'uniplan_design_system';

  static const TextStyle _base = TextStyle(
    fontFamily: fontFamily,
    package: fontPackage,
  );

  static final TextStyle displaySmall = _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );
  static final TextStyle headlineMedium = _base.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
  static final TextStyle titleLarge = _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  static final TextStyle titleMedium = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static final TextStyle titleSmall = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );
  static final TextStyle bodyLarge = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );
  static final TextStyle bodyMedium = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  static final TextStyle bodySmall = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  static final TextStyle labelLarge = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  static final TextStyle labelMedium = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
  static final TextStyle labelSmall = _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static final TextTheme textTheme = TextTheme(
    displaySmall: displaySmall,
    headlineMedium: headlineMedium,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
