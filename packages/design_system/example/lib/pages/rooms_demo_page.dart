import 'package:flutter/material.dart';
import 'package:uniplan_design_system/uniplan_design_system.dart';

import '../gallery_coordinator.dart';
import '../page_host.dart';

/// Um dia da grade, com as aulas daquele dia.
typedef WeekDay = ({String short, String name, List<ScheduleTileViewModel> classes});

/// "Onde é minha aula?": escolhe o dia da semana e vê bloco e sala de cada
/// aula. A busca filtra por disciplina, bloco ou sala.
class RoomsViewModel extends GalleryViewModel {
  int _day = 4; // sexta-feira ("hoje" na demonstração)
  String _query = '';

  static const _mobile = (subject: 'Mobile II', professor: 'Prof.ª Carla Mendes', tone: AppTone.primary);
  static const _ia = (subject: 'Inteligência Artificial', professor: 'Prof. Ricardo Alves', tone: AppTone.accent);
  static const _os = (subject: 'Otimização para Sistemas', professor: 'Prof. Marcelo Tavares', tone: AppTone.success);
  static const _ts = (subject: 'Testes de Software', professor: 'Prof.ª Juliana Rocha', tone: AppTone.ink);
  static const _dw = (subject: 'Desenvolvimento Web', professor: 'Prof. André Lima', tone: AppTone.primary);
  static const _gp = (subject: 'Gerência de Projetos', professor: 'Prof.ª Patrícia Nunes', tone: AppTone.warning);

  static ScheduleTileViewModel _at(
    ({String subject, String professor, AppTone tone}) s,
    String start,
    String end,
    String block,
    String room,
    String floor,
  ) {
    return ScheduleTileViewModel(
      subject: s.subject,
      professor: s.professor,
      tone: s.tone,
      start: start,
      end: end,
      block: block,
      room: room,
      floor: floor,
    );
  }

  static final List<WeekDay> week = [
    (short: 'Seg', name: 'Segunda-feira', classes: [
      _at(_ts, '19:00', '20:40', 'D', 'Lab 1', 'Térreo'),
      _at(_ia, '20:50', '22:30', 'C', 'Sala 204', '2º andar'),
    ]),
    (short: 'Ter', name: 'Terça-feira', classes: [
      _at(_os, '19:00', '22:30', 'B', 'Sala 12', 'Térreo'),
    ]),
    (short: 'Qua', name: 'Quarta-feira', classes: [
      _at(_mobile, '19:00', '20:40', 'C', 'Lab 3', 'Térreo'),
      _at(_dw, '20:50', '22:30', 'A', 'Lab 5', '1º andar'),
    ]),
    (short: 'Qui', name: 'Quinta-feira', classes: [
      _at(_ia, '19:00', '20:40', 'C', 'Sala 204', '2º andar'),
      _at(_ts, '20:50', '22:30', 'D', 'Lab 1', 'Térreo'),
    ]),
    (short: 'Sex', name: 'Sexta-feira', classes: [
      _at(_mobile, '19:00', '20:40', 'C', 'Lab 3', 'Térreo'),
      _at(_gp, '20:50', '22:30', 'A', 'Sala 108', '1º andar'),
    ]),
    (short: 'Sáb', name: 'Sábado', classes: [
      _at(_dw, '08:00', '09:40', 'A', 'Lab 5', '1º andar'),
      _at(_gp, '09:50', '11:30', 'B', 'Auditório', 'Térreo'),
    ]),
  ];

  SheetScaffoldViewModel get scaffold => const SheetScaffoldViewModel(
    title: 'Onde é minha aula?',
    leading: GalleryCoordinator.backButton,
    trailing: GalleryCoordinator.themeButton,
  );

  TextFieldViewModel get search => TextFieldViewModel(
    type: TextFieldType.search,
    hint: 'Disciplina, bloco ou sala',
    onChanged: (value) {
      _query = value;
      notifyListeners();
    },
  );

  SegmentedViewModel get weekdays => SegmentedViewModel(
    segments: [for (final d in week) d.short],
    selectedIndex: _day,
    onSelected: (index) {
      _day = index;
      notifyListeners();
    },
  );

  SectionHeaderViewModel get heading => SectionHeaderViewModel(
    title: _day == 4 ? '${week[_day].name} · hoje' : week[_day].name,
  );

  List<ScheduleTileViewModel> get classes => [
    for (final c in week[_day].classes)
      if (c.matches(_query)) c,
  ];

  StateViewViewModel get empty => StateViewViewModel.empty(
    _query.trim().isEmpty
        ? 'Sem aulas neste dia.'
        : 'Nada encontrado para "${_query.trim()}" neste dia.',
  );
}

class RoomsDemoPage extends StatelessWidget {
  const RoomsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageHost<RoomsViewModel>(
      create: RoomsViewModel.new,
      builder: (context, viewModel) {
        final classes = viewModel.classes;
        return SheetScaffoldFactory.create(
          viewModel.scaffold,
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFieldFactory.create(viewModel.search),
              const SizedBox(height: AppSpacing.md),
              SegmentedFactory.create(viewModel.weekdays),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.sm,
              AppSpacing.screen,
              AppSpacing.xxl,
            ),
            children: [
              SectionHeaderFactory.create(viewModel.heading),
              if (classes.isEmpty)
                StateViewFactory.create(viewModel.empty)
              else
                for (final c in classes) ...[
                  ScheduleTileFactory.create(c),
                  const SizedBox(height: AppSpacing.md),
                ],
            ],
          ),
        );
      },
    );
  }
}
