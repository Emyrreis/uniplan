import 'package:flutter/material.dart';
import 'package:uniplan_design_system/uniplan_design_system.dart';

import '../gallery_coordinator.dart';
import '../page_host.dart';

/// Cards, tiles, badges, barras e avatar. As faltas são um estado só,
/// então o "+1 falta" atualiza o card de número e o card da disciplina.
class CardsViewModel extends GalleryViewModel {
  int _absences = 2;
  static const int _maxAbsences = 18;
  final List<bool> _delivered = [false, false, true];

  SheetScaffoldViewModel get scaffold => const SheetScaffoldViewModel(
    title: 'Cards e tiles',
    leading: GalleryCoordinator.backButton,
    trailing: GalleryCoordinator.themeButton,
  );

  void _addAbsence() {
    if (_absences >= _maxAbsences) return;
    _absences++;
    notifyListeners();
  }

  // ── Números ─────────────────────────────────────────────────────────────

  StatCardViewModel get averageCard => const StatCardViewModel(
    type: StatCardType.card,
    label: 'Média atual',
    value: '9,4',
    caption: 'mínimo 7,0 · Em curso',
  );

  StatCardViewModel get absencesCard => StatCardViewModel(
    type: StatCardType.card,
    label: 'Faltas',
    value: '$_absences',
    suffix: '/ $_maxAbsences',
    highlight: _absences / _maxAbsences >= 0.75,
    action: ButtonViewModel(
      type: ButtonType.accent,
      label: '+1 falta',
      compact: true,
      enabled: _absences < _maxAbsences,
      onPressed: _addAbsence,
    ),
  );

  // ── Disciplinas e aulas ─────────────────────────────────────────────────

  List<SubjectCardViewModel> get subjects => [
    SubjectCardViewModel(
      name: 'Mobile II',
      initials: 'M2',
      tone: AppTone.primary,
      professor: 'Prof.ª Carla Mendes · Bloco C',
      averageLabel: '9,4',
      status: const BadgeViewModel(label: 'Aprovada', tone: AppTone.primary),
      absences: _absences,
      maxAbsences: _maxAbsences,
      onTap: () => GalleryCoordinator.showMessage('Abrir Mobile II'),
    ),
    SubjectCardViewModel(
      name: 'Otimização para Sistemas',
      initials: 'OS',
      tone: AppTone.success,
      professor: 'Prof. Marcelo Tavares · Bloco B',
      averageLabel: '8,8',
      status: const BadgeViewModel(label: 'Em risco', tone: AppTone.warning),
      absences: 14,
      maxAbsences: _maxAbsences,
      onTap: () => GalleryCoordinator.showMessage('Abrir Otimização'),
    ),
  ];

  List<ClassCardViewModel> get classes => const [
    ClassCardViewModel(
      subject: 'Mobile II',
      time: '19:00',
      block: 'C',
      room: 'Lab 3',
      tone: AppTone.primary,
    ),
    ClassCardViewModel(
      subject: 'Inteligência Artificial',
      time: '20:50',
      room: 'Sala 204',
      tone: AppTone.accent,
    ),
  ];

  // ── Atividades ─────────────────────────────────────────────────────────

  List<ActivityTileViewModel> get dueTiles => const [
    ActivityTileViewModel(
      type: ActivityTileType.due,
      kind: ActivityKind.exam,
      title: 'Prova 2',
      subtitle: 'Inteligência Artificial',
      dueLabel: 'Amanhã',
      dueSoon: true,
    ),
    ActivityTileViewModel(
      type: ActivityTileType.due,
      kind: ActivityKind.assignment,
      title: 'Projeto final',
      subtitle: 'Mobile II',
      dueLabel: 'Em 5 dias',
    ),
  ];

  List<ActivityTileViewModel> get gradeTiles => const [
    ActivityTileViewModel(
      type: ActivityTileType.grade,
      kind: ActivityKind.exam,
      title: 'Prova 1',
      subtitle: 'Prova · peso 3 · 02/10',
      gradeLabel: '8,6',
    ),
    ActivityTileViewModel(
      type: ActivityTileType.grade,
      kind: ActivityKind.assignment,
      title: 'Projeto final',
      subtitle: 'Trabalho · peso 2 · 04/11',
    ),
  ];

  List<ActivityTileViewModel> get checkTiles {
    const items = [
      (title: 'Lista 3 — Simplex', subject: 'Otimização · 23:59', kind: ActivityKind.exercise),
      (title: 'Seminário de IA', subject: 'Inteligência Artificial · 19:00', kind: ActivityKind.presentation),
      (title: 'Relatório de casos de teste', subject: 'Testes de Software · 19:00', kind: ActivityKind.assignment),
    ];
    return [
      for (var i = 0; i < items.length; i++)
        ActivityTileViewModel(
          type: ActivityTileType.check,
          kind: items[i].kind,
          title: items[i].title,
          subtitle: items[i].subject,
          checked: _delivered[i],
          onCheckedChanged: (value) {
            _delivered[i] = value;
            notifyListeners();
          },
        ),
    ];
  }

  // ── Avulsos ────────────────────────────────────────────────────────────

  ProgressBarViewModel get semesterBar => const ProgressBarViewModel(
    type: ProgressBarType.labeled,
    value: 0.68,
    trailingLabel: '16 semanas',
  );

  List<AvatarViewModel> get avatars => [
    AvatarViewModel(
      name: 'Emilly Reis',
      size: 56,
      onEdit: () => GalleryCoordinator.showMessage(
        'Abrir: Escolher da galeria · Tirar foto · Remover foto',
      ),
    ),
    const AvatarViewModel(name: 'Ana', tone: AppTone.primary),
    const AvatarViewModel(name: 'Turma Mobile', size: 40, tone: AppTone.success),
  ];
}

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageHost<CardsViewModel>(
      create: CardsViewModel.new,
      builder: (context, viewModel) => SheetScaffoldFactory.create(
        viewModel.scaffold,
        // A barra "labeled" foi feita para a faixa do topo.
        header: ProgressBarFactory.create(viewModel.semesterBar),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'StatCard'),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _onSurface(viewModel.averageCard)),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _onSurface(viewModel.absencesCard)),
              ],
            ),
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'SubjectCard'),
            ),
            for (final subject in viewModel.subjects) ...[
              SubjectCardFactory.create(subject),
              const SizedBox(height: AppSpacing.md),
            ],
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'ClassCard'),
            ),
            Row(
              children: [
                for (final c in viewModel.classes) ...[
                  Expanded(child: ClassCardFactory.create(c)),
                  if (c != viewModel.classes.last)
                    const SizedBox(width: AppSpacing.md),
                ],
              ],
            ),
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'ActivityTile · prazo'),
            ),
            for (final tile in viewModel.dueTiles)
              ActivityTileFactory.create(tile),
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'ActivityTile · nota'),
            ),
            for (final tile in viewModel.gradeTiles)
              ActivityTileFactory.create(tile),
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'ActivityTile · entregue'),
            ),
            for (final tile in viewModel.checkTiles)
              ActivityTileFactory.create(tile),
            SectionHeaderFactory.create(
              const SectionHeaderViewModel(title: 'Avatar (o primeiro é editável)'),
            ),
            Row(
              children: [
                for (final avatar in viewModel.avatars) ...[
                  AvatarFactory.create(avatar),
                  const SizedBox(width: AppSpacing.md),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// O StatCard "card" usa a cor do fundo; aqui ele fica sobre a folha,
  /// então ganha um contorno de superfície para aparecer.
  Widget _onSurface(StatCardViewModel card) {
    return Builder(
      builder: (context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: AppRadius.lgAll,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: StatCardFactory.create(card),
        ),
      ),
    );
  }
}
