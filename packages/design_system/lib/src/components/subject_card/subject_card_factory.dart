import 'package:flutter/widgets.dart';

import 'subject_card_component.dart';
import 'subject_card_view_model.dart';

/// Cria o card de disciplina a partir da [SubjectCardViewModel].
abstract final class SubjectCardFactory {
  static Widget create(SubjectCardViewModel viewModel, {Key? key}) =>
      SubjectCardComponent(viewModel: viewModel, key: key);
}
