import 'package:flutter/painting.dart';

/// Raios de canto.
abstract final class AppRadius {
  static const double sm = 8; // checkbox, ícones pequenos
  static const double md = 16; // ícone de atividade, campos
  static const double lg = 20; // cards
  static const double sheet = 48; // folha de conteúdo e barra de navegação
  static const double pill = 999; // botões, badges, chips

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius sheetTop = BorderRadius.vertical(
    top: Radius.circular(sheet),
  );
}
