import 'package:flutter/widgets.dart';

import 'progress_bar_component.dart';
import 'progress_bar_view_model.dart';

/// Cria a barra certa a partir da [ProgressBarViewModel].
abstract final class ProgressBarFactory {
  static Widget create(ProgressBarViewModel viewModel, {Key? key}) {
    return switch (viewModel.type) {
      ProgressBarType.labeled => LabeledProgressBarComponent(
        viewModel: viewModel,
        key: key,
      ),
      ProgressBarType.thin => ThinProgressBarComponent(
        viewModel: viewModel,
        key: key,
      ),
    };
  }
}
