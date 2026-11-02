import 'package:flutter/widgets.dart';

import 'schedule_tile_component.dart';
import 'schedule_tile_view_model.dart';

/// Cria o card de aula da grade a partir da [ScheduleTileViewModel].
abstract final class ScheduleTileFactory {
  static Widget create(ScheduleTileViewModel viewModel, {Key? key}) =>
      ScheduleTileComponent(viewModel: viewModel, key: key);
}
