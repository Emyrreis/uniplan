import 'package:flutter/widgets.dart';

import 'section_header_component.dart';
import 'section_header_view_model.dart';

/// Cria o cabeçalho de seção a partir da [SectionHeaderViewModel].
abstract final class SectionHeaderFactory {
  static Widget create(SectionHeaderViewModel viewModel, {Key? key}) =>
      SectionHeaderComponent(viewModel: viewModel, key: key);
}
