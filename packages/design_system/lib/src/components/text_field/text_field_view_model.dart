import 'package:flutter/material.dart';

/// Tipos de campo. A [TextFieldFactory] lê o tipo e decide o componente.
enum TextFieldType { text, email, password, number, multiline, search }

/// Dados e estado de um campo de texto.
///
/// O que o usuário digita é delegado para [onChanged] / [onSubmitted];
/// quem guarda o valor é a ViewModel da tela, não o campo.
class TextFieldViewModel {
  const TextFieldViewModel({
    required this.type,
    this.label,
    this.hint,
    this.errorText,
    this.icon,
    this.controller,
    this.enabled = true,
    this.textInputAction,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
  });

  final TextFieldType type;

  /// Texto acima do campo ("E-mail"). O tipo [TextFieldType.search] não tem.
  final String? label;
  final String? hint;

  /// Mensagem de validação; nulo esconde.
  final String? errorText;

  /// Ícone à esquerda. O tipo busca usa a lupa quando nada é informado.
  final IconData? icon;

  final TextEditingController? controller;
  final bool enabled;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  TextInputType get keyboardType => switch (type) {
    TextFieldType.email => TextInputType.emailAddress,
    TextFieldType.number => const TextInputType.numberWithOptions(
      decimal: true,
    ),
    TextFieldType.multiline => TextInputType.multiline,
    _ => TextInputType.text,
  };

  int get maxLines => type == TextFieldType.multiline ? 4 : 1;

  int get minLines => type == TextFieldType.multiline ? 3 : 1;

  IconData? get prefixIcon =>
      icon ?? (type == TextFieldType.search ? Icons.search : null);

  bool get hasLabel => label != null && label!.isNotEmpty;
}
