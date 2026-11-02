import 'package:flutter/widgets.dart';

import 'button_component.dart';
import 'button_view_model.dart';

/// Cria o botão certo a partir da [ButtonViewModel].
///
/// A tela nunca instancia um componente de botão direto: ela monta a
/// ViewModel e pede à fábrica, que decide qual classe concreta usar.
abstract final class ButtonFactory {
  static Widget create(ButtonViewModel viewModel, {Key? key}) {
    return switch (viewModel.type) {
      ButtonType.primary => PrimaryButtonComponent(
        viewModel: viewModel,
        key: key,
      ),
      ButtonType.secondary => SecondaryButtonComponent(
        viewModel: viewModel,
        key: key,
      ),
      ButtonType.accent => AccentButtonComponent(
        viewModel: viewModel,
        key: key,
      ),
      ButtonType.text => TextLinkButtonComponent(
        viewModel: viewModel,
        key: key,
      ),
      ButtonType.icon => IconCircleButtonComponent(
        viewModel: viewModel,
        key: key,
      ),
    };
  }
}
