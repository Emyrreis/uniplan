import 'package:flutter/widgets.dart';

import 'logo_component.dart';
import 'logo_view_model.dart';

/// Cria a logo certa a partir da [LogoViewModel].
abstract final class LogoFactory {
  static Widget create(LogoViewModel viewModel, {Key? key}) {
    return switch (viewModel.type) {
      LogoType.mark => MarkLogoComponent(viewModel: viewModel, key: key),
      LogoType.full => FullLogoComponent(viewModel: viewModel, key: key),
    };
  }
}
