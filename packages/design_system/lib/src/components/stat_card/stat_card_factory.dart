import 'package:flutter/widgets.dart';

import 'stat_card_component.dart';
import 'stat_card_view_model.dart';

/// Cria o bloco de número certo a partir da [StatCardViewModel].
abstract final class StatCardFactory {
  static Widget create(StatCardViewModel viewModel, {Key? key}) {
    return switch (viewModel.type) {
      StatCardType.onHeader => HeaderStatCardComponent(
        viewModel: viewModel,
        key: key,
      ),
      StatCardType.card => SurfaceStatCardComponent(
        viewModel: viewModel,
        key: key,
      ),
    };
  }
}
