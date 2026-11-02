import 'package:flutter/material.dart';
import 'package:uniplan_design_system/uniplan_design_system.dart';

import '../gallery_coordinator.dart';
import '../page_host.dart';

/// Estado de todos os seletores da página.
class SelectionViewModel extends GalleryViewModel {
  static const _filters = ['Pendentes', 'Entregues', 'Todas'];
  static const _kinds = ['Prova', 'Trabalho', 'Lista', 'Seminário'];
  static const _weekdays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

  int _filter = 0;
  Set<int> _kind = {1};
  Set<int> _days = {0, 4};
  final List<bool> _done = [false, true, false];
  bool _reminders = true;

  SheetScaffoldViewModel get scaffold => const SheetScaffoldViewModel(
    title: 'Seleção',
    leading: GalleryCoordinator.backButton,
    trailing: GalleryCoordinator.themeButton,
  );

  SegmentedViewModel get filter => SegmentedViewModel(
    segments: _filters,
    selectedIndex: _filter,
    onSelected: (index) {
      _filter = index;
      notifyListeners();
    },
  );

  String get filterLabel => 'Filtro: ${_filters[_filter]}';

  ChipGroupViewModel get kind {
    final group = ChipGroupViewModel(options: _kinds, selected: _kind);
    return ChipGroupViewModel(
      options: _kinds,
      selected: _kind,
      onToggled: (index) {
        _kind = group.toggled(index);
        notifyListeners();
      },
    );
  }

  ChipGroupViewModel get days {
    final group = ChipGroupViewModel(
      options: _weekdays,
      selected: _days,
      multiSelect: true,
    );
    return ChipGroupViewModel(
      options: _weekdays,
      selected: _days,
      multiSelect: true,
      onToggled: (index) {
        _days = group.toggled(index);
        notifyListeners();
      },
    );
  }

  List<CheckboxViewModel> get checks => [
    for (var i = 0; i < _done.length; i++)
      CheckboxViewModel(
        checked: _done[i],
        label: const ['Ler o capítulo 4', 'Entregar a lista 2', 'Revisar slides'][i],
        onChanged: (value) {
          _done[i] = value;
          notifyListeners();
        },
      ),
  ];

  ToggleViewModel get darkTheme => ToggleViewModel(
    label: 'Tema escuro',
    value: GalleryCoordinator.isDark,
    icon: Icons.dark_mode_outlined,
    onChanged: (value) {
      GalleryCoordinator.setDark(value);
      notifyListeners();
    },
  );

  ToggleViewModel get reminders => ToggleViewModel(
    label: 'Lembretes de prazo',
    value: _reminders,
    icon: Icons.notifications_active_outlined,
    tone: AppTone.primary,
    onChanged: (value) {
      _reminders = value;
      notifyListeners();
    },
  );

  ToggleViewModel get disabledToggle => const ToggleViewModel(
    label: 'Sincronizar (indisponível)',
    value: false,
    icon: Icons.sync_disabled,
    tone: AppTone.neutral,
    enabled: false,
  );
}

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageHost<SelectionViewModel>(
      create: SelectionViewModel.new,
      builder: (context, viewModel) => SheetScaffoldFactory.create(
        viewModel.scaffold,
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'Segmentado'),
            ),
            SegmentedFactory.create(viewModel.filter),
            const SizedBox(height: AppSpacing.xs),
            Text(viewModel.filterLabel),
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'Chips · escolha única'),
            ),
            ChipGroupFactory.create(viewModel.kind),
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'Chips · várias escolhas'),
            ),
            ChipGroupFactory.create(viewModel.days),
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'Checkbox'),
            ),
            for (final check in viewModel.checks) CheckboxFactory.create(check),
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'Switch'),
            ),
            ToggleFactory.create(viewModel.darkTheme),
            ToggleFactory.create(viewModel.reminders),
            ToggleFactory.create(viewModel.disabledToggle),
          ],
        ),
      ),
    );
  }
}
