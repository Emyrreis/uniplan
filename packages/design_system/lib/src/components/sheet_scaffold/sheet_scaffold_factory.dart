import 'package:flutter/widgets.dart';

import 'sheet_scaffold_component.dart';
import 'sheet_scaffold_view_model.dart';

/// Cria a estrutura de tela a partir da [SheetScaffoldViewModel].
abstract final class SheetScaffoldFactory {
  static Widget create(
    SheetScaffoldViewModel viewModel, {
    required Widget body,
    Widget? header,
    Key? key,
  }) {
    return SheetScaffoldComponent(
      viewModel: viewModel,
      header: header,
      body: body,
      key: key,
    );
  }
}
