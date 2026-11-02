import 'package:flutter/material.dart';
import 'package:uniplan_design_system/uniplan_design_system.dart';

import 'gallery_coordinator.dart';
import 'pages/gallery_home_page.dart';

void main() => runApp(const GalleryApp());

/// Sample app do design system: uma vitrine de todos os componentes, nos
/// temas claro e escuro.
class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: galleryThemeMode,
      builder: (_, mode, _) => MaterialApp(
        title: 'UniPlan · Design System',
        debugShowCheckedModeBanner: false,
        navigatorKey: galleryNavigatorKey,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: mode,
        home: const GalleryHomePage(),
      ),
    );
  }
}
