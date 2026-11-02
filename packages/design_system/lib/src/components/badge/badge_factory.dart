import 'package:flutter/widgets.dart';

import 'badge_component.dart';
import 'badge_view_model.dart';

/// Cria a etiqueta a partir da [BadgeViewModel].
abstract final class BadgeFactory {
  static Widget create(BadgeViewModel viewModel, {Key? key}) =>
      BadgeComponent(viewModel: viewModel, key: key);
}
