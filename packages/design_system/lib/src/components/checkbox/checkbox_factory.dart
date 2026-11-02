import 'package:flutter/widgets.dart';

import 'checkbox_component.dart';
import 'checkbox_view_model.dart';

/// Cria a caixa de marcar a partir da [CheckboxViewModel].
abstract final class CheckboxFactory {
  static Widget create(CheckboxViewModel viewModel, {Key? key}) =>
      CheckboxComponent(viewModel: viewModel, key: key);
}
