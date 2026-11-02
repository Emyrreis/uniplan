import 'package:flutter/material.dart';
import 'package:uniplan_design_system/uniplan_design_system.dart';

import '../gallery_coordinator.dart';
import '../page_host.dart';

/// Guarda o que foi digitado e valida e-mail e senha enquanto digita.
class InputsViewModel extends GalleryViewModel {
  String _email = '';
  String _password = '';
  String _query = '';

  SheetScaffoldViewModel get scaffold => const SheetScaffoldViewModel(
    title: 'Campos de texto',
    leading: GalleryCoordinator.backButton,
    trailing: GalleryCoordinator.themeButton,
  );

  String? get _emailError =>
      _email.isNotEmpty && !_email.contains('@') ? 'E-mail inválido.' : null;

  String? get _passwordError => _password.isNotEmpty && _password.length < 6
      ? 'A senha precisa de pelo menos 6 caracteres.'
      : null;

  TextFieldViewModel get search => TextFieldViewModel(
    type: TextFieldType.search,
    hint: 'Buscar atividade',
    onChanged: (value) {
      _query = value.trim();
      notifyListeners();
    },
  );

  String get searchFeedback =>
      _query.isEmpty ? 'Digite para buscar.' : 'Buscando por "$_query"';

  TextFieldViewModel get title => const TextFieldViewModel(
    type: TextFieldType.text,
    label: 'Título',
    hint: 'Projeto final',
    textInputAction: TextInputAction.next,
  );

  TextFieldViewModel get email => TextFieldViewModel(
    type: TextFieldType.email,
    label: 'E-mail',
    hint: 'voce@exemplo.com',
    icon: Icons.mail_outline,
    errorText: _emailError,
    textInputAction: TextInputAction.next,
    autofillHints: const [AutofillHints.email],
    onChanged: (value) {
      _email = value.trim();
      notifyListeners();
    },
  );

  TextFieldViewModel get password => TextFieldViewModel(
    type: TextFieldType.password,
    label: 'Senha',
    icon: Icons.lock_outline,
    errorText: _passwordError,
    autofillHints: const [AutofillHints.password],
    onChanged: (value) {
      _password = value;
      notifyListeners();
    },
  );

  TextFieldViewModel get weight => const TextFieldViewModel(
    type: TextFieldType.number,
    label: 'Peso',
    hint: '2',
  );

  TextFieldViewModel get note => const TextFieldViewModel(
    type: TextFieldType.multiline,
    label: 'Observação',
    hint: 'Opcional',
  );

  TextFieldViewModel get disabled => const TextFieldViewModel(
    type: TextFieldType.text,
    label: 'Desabilitado',
    hint: 'Não editável',
    enabled: false,
  );
}

class InputsPage extends StatelessWidget {
  const InputsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageHost<InputsViewModel>(
      create: InputsViewModel.new,
      builder: (context, viewModel) => SheetScaffoldFactory.create(
        viewModel.scaffold,
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            TextFieldFactory.create(viewModel.search),
            const SizedBox(height: AppSpacing.xs),
            Text(
              viewModel.searchFeedback,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            TextFieldFactory.create(viewModel.title),
            const SizedBox(height: AppSpacing.lg),
            TextFieldFactory.create(viewModel.email),
            const SizedBox(height: AppSpacing.lg),
            TextFieldFactory.create(viewModel.password),
            const SizedBox(height: AppSpacing.lg),
            TextFieldFactory.create(viewModel.weight),
            const SizedBox(height: AppSpacing.lg),
            TextFieldFactory.create(viewModel.note),
            const SizedBox(height: AppSpacing.lg),
            TextFieldFactory.create(viewModel.disabled),
          ],
        ),
      ),
    );
  }
}
