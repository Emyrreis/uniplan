import 'package:flutter/widgets.dart';

import 'class_card_component.dart';
import 'class_card_view_model.dart';

/// Cria o card de aula a partir da [ClassCardViewModel].
abstract final class ClassCardFactory {
  static Widget create(ClassCardViewModel viewModel, {Key? key}) =>
      ClassCardComponent(viewModel: viewModel, key: key);
}
