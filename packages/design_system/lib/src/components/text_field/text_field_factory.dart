import 'package:flutter/widgets.dart';

import 'text_field_component.dart';
import 'text_field_view_model.dart';

/// Cria o campo certo a partir da [TextFieldViewModel].
abstract final class TextFieldFactory {
  static Widget create(TextFieldViewModel viewModel, {Key? key}) {
    return switch (viewModel.type) {
      TextFieldType.password => PasswordTextFieldComponent(
        viewModel: viewModel,
        key: key,
      ),
      TextFieldType.search => SearchTextFieldComponent(
        viewModel: viewModel,
        key: key,
      ),
      _ => StandardTextFieldComponent(viewModel: viewModel, key: key),
    };
  }
}
