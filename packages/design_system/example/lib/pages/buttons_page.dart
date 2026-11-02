import 'package:flutter/material.dart';
import 'package:uniplan_design_system/uniplan_design_system.dart';

import '../gallery_coordinator.dart';
import '../page_host.dart';

/// Estado da página: carregando, habilitado e um contador de toques.
class ButtonsViewModel extends GalleryViewModel {
  bool _loading = false;
  bool _enabled = true;
  int _absences = 2;

  SheetScaffoldViewModel get scaffold => const SheetScaffoldViewModel(
    title: 'Botões',
    leading: GalleryCoordinator.backButton,
    trailing: GalleryCoordinator.themeButton,
  );

  ToggleViewModel get enabledToggle => ToggleViewModel(
    label: 'Botões habilitados',
    value: _enabled,
    icon: Icons.touch_app_outlined,
    onChanged: (value) {
      _enabled = value;
      notifyListeners();
    },
  );

  ButtonViewModel get primary => ButtonViewModel(
    type: ButtonType.primary,
    label: 'Entrar',
    expanded: true,
    enabled: _enabled,
    loading: _loading,
    onPressed: _simulateLoading,
  );

  ButtonViewModel get secondary => ButtonViewModel(
    type: ButtonType.secondary,
    label: 'Sair da conta',
    icon: Icons.logout,
    expanded: true,
    enabled: _enabled,
    onPressed: () => GalleryCoordinator.showMessage('Secundário tocado.'),
  );

  ButtonViewModel get accent => ButtonViewModel(
    type: ButtonType.accent,
    label: '+1 falta',
    compact: true,
    enabled: _enabled,
    onPressed: () {
      _absences++;
      notifyListeners();
    },
  );

  String get absencesLabel => 'Faltas registradas: $_absences';

  ButtonViewModel get text => ButtonViewModel(
    type: ButtonType.text,
    label: 'Esqueci minha senha',
    enabled: _enabled,
    onPressed: () => GalleryCoordinator.showMessage('Link de texto tocado.'),
  );

  ButtonViewModel get icon => ButtonViewModel(
    type: ButtonType.icon,
    icon: Icons.notifications_none,
    semanticLabel: 'Notificações',
    enabled: _enabled,
    onPressed: () => GalleryCoordinator.showMessage('Ícone tocado.'),
  );

  /// Mostra o estado "carregando" por 2 segundos.
  Future<void> _simulateLoading() async {
    _loading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(seconds: 2));
    _loading = false;
    notifyListeners();
  }
}

class ButtonsPage extends StatelessWidget {
  const ButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageHost<ButtonsViewModel>(
      create: ButtonsViewModel.new,
      builder: (context, viewModel) => SheetScaffoldFactory.create(
        viewModel.scaffold,
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            ToggleFactory.create(viewModel.enabledToggle),
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'Primário (toque: carregando)'),
            ),
            ButtonFactory.create(viewModel.primary),
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'Secundário'),
            ),
            ButtonFactory.create(viewModel.secondary),
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'Destaque (compacto)'),
            ),
            Row(
              children: [
                ButtonFactory.create(viewModel.accent),
                const SizedBox(width: AppSpacing.md),
                Text(viewModel.absencesLabel),
              ],
            ),
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'Texto e ícone'),
            ),
            Row(
              children: [
                ButtonFactory.create(viewModel.text),
                const Spacer(),
                ButtonFactory.create(viewModel.icon),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
