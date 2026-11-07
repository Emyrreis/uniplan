import 'package:flutter/material.dart';
import 'package:uniplan_design_system/uniplan_design_system.dart';

import '../gallery_coordinator.dart';
import '../page_host.dart';

/// Tela de Cadastro montada só com componentes do design system.
///
/// As regras são as mesmas do `POST /auth/register` (docs/API.md):
/// nome com 2+ letras, e-mail válido e ainda não cadastrado, senha com 6+
/// caracteres. "Confirmar senha" é checado só no app.
class RegisterViewModel extends GalleryViewModel {
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirm = '';
  bool _loading = false;

  /// E-mail que o servidor mockado já conhece (simula o 409 da API).
  static const _takenEmail = 'emilly@projetofinal.dev';
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  SheetScaffoldViewModel get scaffold => const SheetScaffoldViewModel(
    title: 'Criar conta',
    subtitle: 'Leva menos de um minuto',
    leading: GalleryCoordinator.backButton,
    trailing: GalleryCoordinator.themeButton,
  );

  LogoViewModel get logo => const LogoViewModel(size: 48, onHeader: true);

  // ── Validação (só mostra erro depois que o campo foi preenchido) ─────────

  String? get _nameError =>
      _name.isNotEmpty && _name.trim().length < 2 ? 'Use pelo menos 2 letras.' : null;

  String? get _emailError {
    final email = _email.trim();
    if (email.isEmpty) return null;
    if (!_emailPattern.hasMatch(email)) return 'E-mail inválido.';
    if (email.toLowerCase() == _takenEmail) {
      return 'Já existe uma conta com este e-mail.';
    }
    return null;
  }

  bool get _passwordOk => _password.length >= 6;

  String? get _confirmError =>
      _confirm.isNotEmpty && _confirm != _password ? 'As senhas não são iguais.' : null;

  bool get _valid =>
      _name.trim().length >= 2 &&
      _email.trim().isNotEmpty &&
      _emailError == null &&
      _passwordOk &&
      _confirm == _password;

  // ── ViewModels dos componentes ───────────────────────────────────────────

  TextFieldViewModel get name => TextFieldViewModel(
    type: TextFieldType.text,
    label: 'Nome',
    hint: 'Como quer ser chamada(o)',
    errorText: _nameError,
    textInputAction: TextInputAction.next,
    autofillHints: const [AutofillHints.name],
    onChanged: (value) => _set(() => _name = value),
  );

  TextFieldViewModel get email => TextFieldViewModel(
    type: TextFieldType.email,
    label: 'E-mail',
    hint: 'voce@exemplo.com',
    errorText: _emailError,
    textInputAction: TextInputAction.next,
    autofillHints: const [AutofillHints.email],
    onChanged: (value) => _set(() => _email = value),
  );

  TextFieldViewModel get password => TextFieldViewModel(
    type: TextFieldType.password,
    label: 'Senha',
    textInputAction: TextInputAction.next,
    autofillHints: const [AutofillHints.newPassword],
    onChanged: (value) => _set(() => _password = value),
  );

  /// Regra da senha, que fica verde quando é cumprida.
  BadgeViewModel get passwordRule => BadgeViewModel(
    label: _passwordOk ? '✓ Mínimo de 6 caracteres' : 'Mínimo de 6 caracteres',
    tone: _passwordOk ? AppTone.success : AppTone.neutral,
  );

  TextFieldViewModel get confirm => TextFieldViewModel(
    type: TextFieldType.password,
    label: 'Confirmar senha',
    errorText: _confirmError,
    autofillHints: const [AutofillHints.newPassword],
    onChanged: (value) => _set(() => _confirm = value),
  );

  ButtonViewModel get submit => ButtonViewModel(
    type: ButtonType.primary,
    label: 'Criar conta',
    expanded: true,
    enabled: _valid,
    loading: _loading,
    onPressed: _submit,
  );

  ButtonViewModel get goToLogin => const ButtonViewModel(
    type: ButtonType.text,
    label: 'Já tem conta? Entrar',
    onPressed: GalleryCoordinator.back,
  );

  void _set(VoidCallback change) {
    change();
    notifyListeners();
  }

  /// Simula a chamada à API: carregando por 1,5 s e depois a mensagem.
  Future<void> _submit() async {
    _set(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    _set(() => _loading = false);
    GalleryCoordinator.showMessage('Conta criada! Bem-vinda(o), ${_name.trim()}.');
  }
}

class RegisterDemoPage extends StatelessWidget {
  const RegisterDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageHost<RegisterViewModel>(
      create: RegisterViewModel.new,
      builder: (context, viewModel) => SheetScaffoldFactory.create(
        viewModel.scaffold,
        header: Center(child: LogoFactory.create(viewModel.logo)),
        body: AutofillGroup(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screen),
            children: [
              TextFieldFactory.create(viewModel.name),
              const SizedBox(height: AppSpacing.lg),
              TextFieldFactory.create(viewModel.email),
              const SizedBox(height: AppSpacing.lg),
              TextFieldFactory.create(viewModel.password),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: BadgeFactory.create(viewModel.passwordRule),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFieldFactory.create(viewModel.confirm),
              const SizedBox(height: AppSpacing.xl),
              ButtonFactory.create(viewModel.submit),
              const SizedBox(height: AppSpacing.sm),
              Center(child: ButtonFactory.create(viewModel.goToLogin)),
            ],
          ),
        ),
      ),
    );
  }
}
