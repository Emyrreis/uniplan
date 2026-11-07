import 'package:flutter_test/flutter_test.dart';
import 'package:uniplan_design_system/uniplan_design_system.dart';

void main() {
  group('ButtonViewModel', () {
    test('action é nula enquanto carrega ou desabilitado', () {
      void tap() {}
      expect(
        const ButtonViewModel(type: ButtonType.primary).action,
        isNull,
        reason: 'sem onPressed',
      );
      expect(
        ButtonViewModel(type: ButtonType.primary, onPressed: tap).action,
        isNotNull,
      );
      expect(
        ButtonViewModel(
          type: ButtonType.primary,
          loading: true,
          onPressed: tap,
        ).action,
        isNull,
      );
      expect(
        ButtonViewModel(
          type: ButtonType.primary,
          enabled: false,
          onPressed: tap,
        ).action,
        isNull,
      );
    });
  });

  group('SegmentedViewModel', () {
    test('marca o segmento escolhido e delega o toque', () {
      int? picked;
      final vm = SegmentedViewModel(
        segments: const ['A', 'B', 'C'],
        selectedIndex: 1,
        onSelected: (i) => picked = i,
      );
      expect(vm.items.map((e) => e.selected), [false, true, false]);
      vm.items[2].onTap!();
      expect(picked, 2);
    });
  });

  group('ChipGroupViewModel.toggled', () {
    test('escolha única troca a seleção', () {
      const vm = ChipGroupViewModel(options: ['a', 'b'], selected: {0});
      expect(vm.toggled(1), {1});
    });

    test('várias escolhas liga e desliga', () {
      const vm = ChipGroupViewModel(
        options: ['a', 'b', 'c'],
        selected: {0},
        multiSelect: true,
      );
      expect(vm.toggled(2), {0, 2});
      expect(vm.toggled(0), <int>{});
    });
  });

  group('SubjectCardViewModel', () {
    SubjectCardViewModel card(int absences) => SubjectCardViewModel(
      name: 'Mobile II',
      initials: 'M2',
      tone: AppTone.primary,
      averageLabel: '9,1',
      status: const BadgeViewModel(label: 'Aprovada'),
      absences: absences,
      maxAbsences: 20,
    );

    test('a partir de 75% das faltas fica em risco', () {
      expect(card(14).absenceAtRisk, isFalse);
      expect(card(15).absenceAtRisk, isTrue);
      expect(card(15).absenceBar.tone, AppTone.warning);
    });

    test('legenda das faltas', () {
      expect(card(2).absenceBar.caption, 'Faltas 2 de 20');
    });
  });

  group('AvatarViewModel editável', () {
    test('só vira botão com onEdit', () {
      expect(const AvatarViewModel(name: 'Emilly').editable, isFalse);
      expect(AvatarViewModel(name: 'Emilly', onEdit: () {}).editable, isTrue);
    });
  });

  group('AvatarViewModel.initials', () {
    test('primeira e última inicial', () {
      expect(const AvatarViewModel(name: 'Emilly Reis').initials, 'ER');
      expect(const AvatarViewModel(name: 'emilly').initials, 'E');
      expect(const AvatarViewModel(name: '  ').initials, '?');
    });
  });

  group('ProgressBarViewModel', () {
    test('corta valores fora de 0..1', () {
      const over = ProgressBarViewModel(type: ProgressBarType.thin, value: 1.4);
      expect(over.share, 1.0);
      expect(over.percentLabel, '100%');
    });
  });

  group('Salas (bloco e sala)', () {
    const aula = ScheduleTileViewModel(
      subject: 'Mobile II',
      start: '19:00',
      end: '20:40',
      block: 'C',
      room: 'Lab 3',
      floor: 'Térreo',
    );

    test('a busca encontra por disciplina, bloco ou sala', () {
      expect(aula.matches(''), isTrue);
      expect(aula.matches('mobile'), isTrue);
      expect(aula.matches('bloco c'), isTrue);
      expect(aula.matches('lab 3'), isTrue);
      expect(aula.matches('sala 204'), isFalse);
    });

    test('o ClassCard mostra horário, bloco e sala', () {
      const card = ClassCardViewModel(
        subject: 'Mobile II',
        time: '19:00',
        block: 'C',
        room: 'Lab 3',
      );
      expect(card.details, '19:00 · Bloco C · Lab 3');
    });
  });

  group('ActivityTileViewModel', () {
    test('prazo próximo usa o tom de destaque', () {
      const tile = ActivityTileViewModel(
        type: ActivityTileType.due,
        kind: ActivityKind.exam,
        title: 'Prova 2',
        dueLabel: 'Amanhã',
        dueSoon: true,
      );
      expect(tile.dueBadge.tone, AppTone.accent);
      expect(tile.gradeText, 'Pendente');
    });
  });
}
