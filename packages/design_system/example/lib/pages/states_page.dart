import 'package:flutter/material.dart';
import 'package:uniplan_design_system/uniplan_design_system.dart';

import '../gallery_coordinator.dart';
import '../page_host.dart';

/// Alterna entre carregando, vazio e erro. "Tentar de novo" simula uma
/// recarga: carregando por 1,5 s e depois vazio.
class StatesViewModel extends GalleryViewModel {
  StateViewType _state = StateViewType.loading;

  SheetScaffoldViewModel get scaffold => const SheetScaffoldViewModel(
    title: 'Estados de tela',
    leading: GalleryCoordinator.backButton,
    trailing: GalleryCoordinator.themeButton,
  );

  SegmentedViewModel get picker => SegmentedViewModel(
    segments: const ['Carregando', 'Vazio', 'Erro'],
    selectedIndex: _state.index,
    onSelected: (index) {
      _state = StateViewType.values[index];
      notifyListeners();
    },
  );

  StateViewViewModel get current => switch (_state) {
    StateViewType.loading => const StateViewViewModel.loading(),
    StateViewType.empty => const StateViewViewModel.empty(
      'Nenhuma atividade pendente. Aproveite!',
    ),
    StateViewType.error => StateViewViewModel.error(
      'Sem conexão. Verifique sua internet e tente de novo.',
      onRetry: _retry,
    ),
  };

  Future<void> _retry() async {
    _state = StateViewType.loading;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    _state = StateViewType.empty;
    notifyListeners();
  }
}

class StatesPage extends StatelessWidget {
  const StatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageHost<StatesViewModel>(
      create: StatesViewModel.new,
      builder: (context, viewModel) => SheetScaffoldFactory.create(
        viewModel.scaffold,
        header: SegmentedFactory.create(viewModel.picker),
        body: StateViewFactory.create(viewModel.current),
      ),
    );
  }
}
