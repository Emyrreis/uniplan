import 'package:flutter/widgets.dart';

import 'chip_group_component.dart';
import 'chip_group_view_model.dart';

/// Cria o grupo de chips a partir da [ChipGroupViewModel].
abstract final class ChipGroupFactory {
  static Widget create(ChipGroupViewModel viewModel, {Key? key}) =>
      ChipGroupComponent(viewModel: viewModel, key: key);
}
