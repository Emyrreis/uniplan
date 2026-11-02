import 'package:flutter/widgets.dart';

import 'avatar_component.dart';
import 'avatar_view_model.dart';

/// Cria o avatar a partir da [AvatarViewModel].
abstract final class AvatarFactory {
  static Widget create(AvatarViewModel viewModel, {Key? key}) =>
      AvatarComponent(viewModel: viewModel, key: key);
}
