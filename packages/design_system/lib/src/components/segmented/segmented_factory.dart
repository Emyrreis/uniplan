import 'package:flutter/widgets.dart';

import 'segmented_component.dart';
import 'segmented_view_model.dart';

/// Cria o controle segmentado a partir da [SegmentedViewModel].
abstract final class SegmentedFactory {
  static Widget create(SegmentedViewModel viewModel, {Key? key}) =>
      SegmentedComponent(viewModel: viewModel, key: key);
}
