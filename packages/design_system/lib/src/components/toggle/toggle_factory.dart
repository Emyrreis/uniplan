import 'package:flutter/widgets.dart';

import 'toggle_component.dart';
import 'toggle_view_model.dart';

/// Cria a linha com switch a partir da [ToggleViewModel].
abstract final class ToggleFactory {
  static Widget create(ToggleViewModel viewModel, {Key? key}) =>
      ToggleComponent(viewModel: viewModel, key: key);
}
