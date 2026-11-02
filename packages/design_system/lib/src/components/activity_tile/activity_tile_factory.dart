import 'package:flutter/widgets.dart';

import 'activity_tile_component.dart';
import 'activity_tile_view_model.dart';

/// Cria o tile certo a partir da [ActivityTileViewModel].
abstract final class ActivityTileFactory {
  static Widget create(ActivityTileViewModel viewModel, {Key? key}) {
    return switch (viewModel.type) {
      ActivityTileType.due => DueActivityTileComponent(
        viewModel: viewModel,
        key: key,
      ),
      ActivityTileType.grade => GradeActivityTileComponent(
        viewModel: viewModel,
        key: key,
      ),
      ActivityTileType.check => CheckActivityTileComponent(
        viewModel: viewModel,
        key: key,
      ),
    };
  }
}
