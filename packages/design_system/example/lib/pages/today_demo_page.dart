import 'package:flutter/material.dart';
import 'package:uniplan_design_system/uniplan_design_system.dart';

import '../gallery_coordinator.dart';
import '../page_host.dart';
import 'rooms_demo_page.dart';

/// A tela "Hoje" do protótipo, montada só com componentes do design system.
/// Os dados são fixos: aqui o objetivo é mostrar a composição.
class TodayDemoViewModel extends GalleryViewModel {
  int _tab = 0;
  final Set<int> _done = {};

  static const _tabs = ['Hoje', 'Disciplinas', 'Atividades', 'Perfil'];

  int get tab => _tab;
  bool get isToday => _tab == 0;

  SheetScaffoldViewModel get scaffold => SheetScaffoldViewModel(
    title: isToday ? 'Olá, Emilly' : _tabs[_tab],
    subtitle: isToday ? 'Sexta-feira, 30 de outubro' : null,
    leading: GalleryCoordinator.backButton,
    trailing: GalleryCoordinator.themeButton,
    floatingAction: _tab == 2
        ? ButtonViewModel(
            type: ButtonType.icon,
            icon: Icons.add,
            semanticLabel: 'Nova atividade',
            onPressed: () => GalleryCoordinator.showMessage('Nova atividade'),
          )
        : null,
    navBar: NavBarViewModel(
      destinations: const [
        (icon: Icons.home_outlined, label: 'Hoje'),
        (icon: Icons.menu_book_outlined, label: 'Disciplinas'),
        (icon: Icons.calendar_month_outlined, label: 'Atividades'),
        (icon: Icons.person_outline, label: 'Perfil'),
      ],
      selectedIndex: _tab,
      onSelected: (index) {
        _tab = index;
        notifyListeners();
      },
    ),
  );

  StatCardViewModel get average => const StatCardViewModel(
    type: StatCardType.onHeader,
    label: 'Média geral',
    value: '8,2',
  );

  StatCardViewModel get pending => StatCardViewModel(
    type: StatCardType.onHeader,
    label: 'Pendências',
    value: '${3 - _done.length}',
    suffix: 'entregas',
    highlight: true,
  );

  ProgressBarViewModel get semester => const ProgressBarViewModel(
    type: ProgressBarType.labeled,
    value: 0.68,
    trailingLabel: '16 semanas',
  );

  SectionHeaderViewModel get classesHeader => SectionHeaderViewModel(
    title: 'Aulas de hoje',
    actionLabel: 'Ver salas',
    onAction: () => GalleryCoordinator.open(const RoomsDemoPage()),
  );

  List<ClassCardViewModel> get classes => [
    ClassCardViewModel(
      subject: 'Mobile II',
      time: '19:00',
      block: 'C',
      room: 'Lab 3',
      onTap: () => GalleryCoordinator.open(const RoomsDemoPage()),
    ),
    ClassCardViewModel(
      subject: 'Inteligência Artificial',
      time: '20:50',
      block: 'C',
      room: 'Sala 204',
      tone: AppTone.accent,
      onTap: () => GalleryCoordinator.open(const RoomsDemoPage()),
    ),
  ];

  SectionHeaderViewModel get tasksHeader => SectionHeaderViewModel(
    title: 'Próximas entregas',
    actionLabel: 'Agenda',
    onAction: () => _goTo(2),
  );

  /// Tocar numa entrega marca/desmarca como feita (some das pendências).
  List<ActivityTileViewModel> get tasks {
    const items = [
      (title: 'Prova 2', subject: 'Inteligência Artificial', due: 'Amanhã', soon: true, kind: ActivityKind.exam),
      (title: 'Projeto final', subject: 'Mobile II', due: 'Em 5 dias', soon: false, kind: ActivityKind.assignment),
      (title: 'Lista 3 — Simplex', subject: 'Otimização', due: '12/11', soon: false, kind: ActivityKind.exercise),
    ];
    return [
      for (var i = 0; i < items.length; i++)
        ActivityTileViewModel(
          type: _done.contains(i) ? ActivityTileType.check : ActivityTileType.due,
          kind: items[i].kind,
          title: items[i].title,
          subtitle: '${items[i].subject} · ${items[i].kind.label}',
          dueLabel: items[i].due,
          dueSoon: items[i].soon,
          checked: _done.contains(i),
          onCheckedChanged: (_) => _toggleDone(i),
          onTap: () => _toggleDone(i),
        ),
    ];
  }

  StateViewViewModel get otherTab =>
      StateViewViewModel.empty('A aba "${_tabs[_tab]}" entra no app final.');

  void _toggleDone(int index) {
    if (!_done.remove(index)) _done.add(index);
    notifyListeners();
  }

  void _goTo(int tab) {
    _tab = tab;
    notifyListeners();
  }
}

class TodayDemoPage extends StatelessWidget {
  const TodayDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageHost<TodayDemoViewModel>(
      create: TodayDemoViewModel.new,
      builder: (context, viewModel) => SheetScaffoldFactory.create(
        viewModel.scaffold,
        header: viewModel.isToday ? _TodayHeader(viewModel: viewModel) : null,
        body: viewModel.isToday
            ? _TodayBody(viewModel: viewModel)
            : StateViewFactory.create(viewModel.otherTab),
      ),
    );
  }
}

class _TodayHeader extends StatelessWidget {
  const _TodayHeader({required this.viewModel});

  final TodayDemoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final divider = context.semanticColors.onHeader.withValues(alpha: 0.4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(child: StatCardFactory.create(viewModel.average)),
              VerticalDivider(color: divider, width: AppSpacing.xl),
              Expanded(child: StatCardFactory.create(viewModel.pending)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ProgressBarFactory.create(viewModel.semester),
      ],
    );
  }
}

class _TodayBody extends StatelessWidget {
  const _TodayBody({required this.viewModel});

  final TodayDemoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final classes = viewModel.classes;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.sm,
        AppSpacing.screen,
        AppSpacing.xxl,
      ),
      children: [
        SectionHeaderFactory.create(viewModel.classesHeader),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: ClassCardFactory.create(classes[0])),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: ClassCardFactory.create(classes[1])),
          ],
        ),
        SectionHeaderFactory.create(viewModel.tasksHeader),
        for (final task in viewModel.tasks) ActivityTileFactory.create(task),
      ],
    );
  }
}
