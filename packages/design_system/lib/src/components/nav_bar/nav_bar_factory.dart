import 'package:flutter/widgets.dart';

import 'nav_bar_component.dart';
import 'nav_bar_view_model.dart';

/// Cria a barra de navegação a partir da [NavBarViewModel].
abstract final class NavBarFactory {
  static Widget create(NavBarViewModel viewModel, {Key? key}) =>
      NavBarComponent(viewModel: viewModel, key: key);
}
