import '../buttons/button_view_model.dart';
import '../nav_bar/nav_bar_view_model.dart';

/// Estrutura de toda tela do app: faixa colorida no topo (título, botões,
/// números) e uma folha arredondada com o conteúdo.
class SheetScaffoldViewModel {
  const SheetScaffoldViewModel({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.floatingAction,
    this.navBar,
  });

  final String title;
  final String? subtitle;

  /// Botão à esquerda do título, normalmente "voltar" (tipo icon).
  final ButtonViewModel? leading;

  /// Botão à direita do título (tipo icon).
  final ButtonViewModel? trailing;

  /// Botão flutuante redondo (ex.: "Nova atividade"). Usa `icon` e
  /// `semanticLabel` da ViewModel.
  final ButtonViewModel? floatingAction;

  /// Barra inferior; nula nas telas empilhadas (detalhe, formulário).
  final NavBarViewModel? navBar;
}
