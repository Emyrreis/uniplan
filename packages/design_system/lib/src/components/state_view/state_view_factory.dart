import 'package:flutter/widgets.dart';

import 'state_view_component.dart';
import 'state_view_view_model.dart';

/// Cria o estado certo a partir da [StateViewViewModel].
abstract final class StateViewFactory {
  static Widget create(StateViewViewModel viewModel, {Key? key}) {
    return switch (viewModel.type) {
      StateViewType.loading => LoadingStateComponent(
        viewModel: viewModel,
        key: key,
      ),
      StateViewType.empty => EmptyStateComponent(
        viewModel: viewModel,
        key: key,
      ),
      StateViewType.error => ErrorStateComponent(
        viewModel: viewModel,
        key: key,
      ),
    };
  }
}
