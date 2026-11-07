import 'package:flutter/material.dart';
import 'package:uniplan_design_system/uniplan_design_system.dart';

import '../gallery_coordinator.dart';
import '../page_host.dart';
import 'buttons_page.dart';
import 'cards_page.dart';
import 'inputs_page.dart';
import 'register_demo_page.dart';
import 'rooms_demo_page.dart';
import 'selection_page.dart';
import 'states_page.dart';
import 'today_demo_page.dart';
import 'tokens_page.dart';

/// Uma entrada do menu da galeria.
typedef GallerySection = ({
  String title,
  IconData icon,
  Widget Function() page,
});

/// Menu da galeria, dividido em grupos.
class GalleryHomeViewModel extends GalleryViewModel {
  static final List<GallerySection> foundations = [
    (title: 'Logo, cores, tipografia e tons', icon: Icons.palette_outlined, page: TokensPage.new),
  ];

  static final List<GallerySection> components = [
    (title: 'Botões', icon: Icons.smart_button_outlined, page: ButtonsPage.new),
    (title: 'Campos de texto', icon: Icons.edit_outlined, page: InputsPage.new),
    (title: 'Seleção', icon: Icons.toggle_on_outlined, page: SelectionPage.new),
    (title: 'Cards, tiles e badges', icon: Icons.view_agenda_outlined, page: CardsPage.new),
    (title: 'Estados de tela', icon: Icons.hourglass_empty, page: StatesPage.new),
  ];

  static final List<GallerySection> screens = [
    (title: 'Cadastro montado', icon: Icons.person_add_alt, page: RegisterDemoPage.new),
    (title: 'Tela "Hoje" montada', icon: Icons.phone_android, page: TodayDemoPage.new),
    (title: 'Onde é minha aula? (salas)', icon: Icons.place_outlined, page: RoomsDemoPage.new),
  ];

  SheetScaffoldViewModel get scaffold => const SheetScaffoldViewModel(
    title: 'UniPlan',
    subtitle: 'Design system · sample app',
    trailing: GalleryCoordinator.themeButton,
  );

  /// Cada entrada vira um botão secundário de largura total.
  ButtonViewModel entry(GallerySection section) => ButtonViewModel(
    type: ButtonType.secondary,
    label: section.title,
    icon: section.icon,
    expanded: true,
    onPressed: () => GalleryCoordinator.open(section.page()),
  );
}

class GalleryHomePage extends StatelessWidget {
  const GalleryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageHost<GalleryHomeViewModel>(
      create: GalleryHomeViewModel.new,
      builder: (context, viewModel) => SheetScaffoldFactory.create(
        viewModel.scaffold,
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            _group(viewModel, 'Fundamentos', GalleryHomeViewModel.foundations),
            _group(viewModel, 'Componentes', GalleryHomeViewModel.components),
            _group(viewModel, 'Telas de exemplo', GalleryHomeViewModel.screens),
          ],
        ),
      ),
    );
  }

  Widget _group(
    GalleryHomeViewModel viewModel,
    String title,
    List<GallerySection> sections,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeaderFactory.create(SectionHeaderViewModel(title: title)),
        for (final section in sections) ...[
          ButtonFactory.create(viewModel.entry(section)),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
