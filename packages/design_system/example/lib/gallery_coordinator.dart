import 'package:flutter/material.dart';
import 'package:uniplan_design_system/uniplan_design_system.dart';

/// Chave do Navigator: o coordinator troca de página sem receber um
/// BuildContext da View.
final GlobalKey<NavigatorState> galleryNavigatorKey =
    GlobalKey<NavigatorState>();

/// Tema escolhido. Um ValueNotifier basta: um valor, sem pacote.
final ValueNotifier<ThemeMode> galleryThemeMode = ValueNotifier(
  ThemeMode.light,
);

/// Navegação e mensagens da galeria. As ViewModels chamam o coordinator;
/// as Views nunca chamam o Navigator direto.
abstract final class GalleryCoordinator {
  static void open(Widget page) {
    galleryNavigatorKey.currentState?.push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  static void back() => galleryNavigatorKey.currentState?.maybePop();

  static void showMessage(String message) {
    final context = galleryNavigatorKey.currentContext;
    if (context == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  static bool get isDark => galleryThemeMode.value == ThemeMode.dark;

  static void setDark(bool dark) =>
      galleryThemeMode.value = dark ? ThemeMode.dark : ThemeMode.light;

  static void toggleTheme() => setDark(!isDark);

  /// Botões do topo, iguais em todas as páginas.
  static const ButtonViewModel backButton = ButtonViewModel(
    type: ButtonType.icon,
    icon: Icons.arrow_back,
    semanticLabel: 'Voltar',
    onPressed: back,
  );

  static const ButtonViewModel themeButton = ButtonViewModel(
    type: ButtonType.icon,
    icon: Icons.brightness_6_outlined,
    semanticLabel: 'Alternar tema claro/escuro',
    onPressed: toggleTheme,
  );
}
