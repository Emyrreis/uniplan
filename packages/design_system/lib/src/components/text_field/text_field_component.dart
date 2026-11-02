import 'package:flutter/material.dart';

import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';
import 'text_field_view_model.dart';

/// Rótulo acima + campo. Compartilhado pelos componentes de campo.
class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.viewModel, required this.field});

  final TextFieldViewModel viewModel;
  final Widget field;

  @override
  Widget build(BuildContext context) {
    if (!viewModel.hasLabel) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(viewModel.label!, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        field,
      ],
    );
  }
}

InputDecoration _decoration(TextFieldViewModel viewModel, {Widget? suffix}) {
  final prefix = viewModel.prefixIcon;
  return InputDecoration(
    hintText: viewModel.hint,
    errorText: viewModel.errorText,
    prefixIcon: prefix == null ? null : Icon(prefix, size: 20),
    suffixIcon: suffix,
  );
}

/// Campo comum: texto, e-mail, número e multilinha.
class StandardTextFieldComponent extends StatelessWidget {
  const StandardTextFieldComponent({required this.viewModel, super.key});

  final TextFieldViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _LabeledField(
      viewModel: viewModel,
      field: TextField(
        controller: viewModel.controller,
        enabled: viewModel.enabled,
        keyboardType: viewModel.keyboardType,
        textInputAction: viewModel.textInputAction,
        autofillHints: viewModel.autofillHints,
        minLines: viewModel.minLines,
        maxLines: viewModel.maxLines,
        onChanged: viewModel.onChanged,
        onSubmitted: viewModel.onSubmitted,
        decoration: _decoration(viewModel),
      ),
    );
  }
}

/// Campo de senha com o botão de mostrar/ocultar.
///
/// Mostrar ou não a senha é estado só do visual (não interessa à tela),
/// por isso fica aqui dentro, num StatefulWidget.
class PasswordTextFieldComponent extends StatefulWidget {
  const PasswordTextFieldComponent({required this.viewModel, super.key});

  final TextFieldViewModel viewModel;

  @override
  State<PasswordTextFieldComponent> createState() =>
      _PasswordTextFieldComponentState();
}

class _PasswordTextFieldComponentState
    extends State<PasswordTextFieldComponent> {
  bool _obscure = true;

  void _toggle() => setState(() => _obscure = !_obscure);

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return _LabeledField(
      viewModel: viewModel,
      field: TextField(
        controller: viewModel.controller,
        enabled: viewModel.enabled,
        obscureText: _obscure,
        enableSuggestions: false,
        autocorrect: false,
        textInputAction: viewModel.textInputAction,
        autofillHints: viewModel.autofillHints,
        onChanged: viewModel.onChanged,
        onSubmitted: viewModel.onSubmitted,
        decoration: _decoration(
          viewModel,
          suffix: IconButton(
            tooltip: _obscure ? 'Mostrar senha' : 'Ocultar senha',
            style: IconButton.styleFrom(backgroundColor: Colors.transparent),
            onPressed: _toggle,
            icon: Icon(
              _obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
        ),
      ),
    );
  }
}

/// Busca: pílula com lupa, sem rótulo.
class SearchTextFieldComponent extends StatelessWidget {
  const SearchTextFieldComponent({required this.viewModel, super.key});

  final TextFieldViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: viewModel.controller,
      enabled: viewModel.enabled,
      textInputAction: TextInputAction.search,
      onChanged: viewModel.onChanged,
      onSubmitted: viewModel.onSubmitted,
      decoration: _decoration(viewModel).copyWith(
        border: const OutlineInputBorder(
          borderRadius: AppRadius.pillAll,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.pillAll,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.pillAll,
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
