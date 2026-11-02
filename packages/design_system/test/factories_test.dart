import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uniplan_design_system/uniplan_design_system.dart';
import 'package:uniplan_design_system/src/components/activity_tile/activity_tile_component.dart';
import 'package:uniplan_design_system/src/components/buttons/button_component.dart';
import 'package:uniplan_design_system/src/components/state_view/state_view_component.dart';
import 'package:uniplan_design_system/src/components/text_field/text_field_component.dart';

/// Coloca o widget dentro do tema do design system.
Widget _host(Widget child, {bool dark = false}) {
  return MaterialApp(
    theme: dark ? AppTheme.dark() : AppTheme.light(),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('A Factory decide o componente pelo tipo', () {
    test('ButtonFactory', () {
      expect(
        ButtonFactory.create(const ButtonViewModel(type: ButtonType.primary)),
        isA<PrimaryButtonComponent>(),
      );
      expect(
        ButtonFactory.create(const ButtonViewModel(type: ButtonType.accent)),
        isA<AccentButtonComponent>(),
      );
      expect(
        ButtonFactory.create(const ButtonViewModel(type: ButtonType.icon)),
        isA<IconCircleButtonComponent>(),
      );
    });

    test('TextFieldFactory', () {
      expect(
        TextFieldFactory.create(
          const TextFieldViewModel(type: TextFieldType.password),
        ),
        isA<PasswordTextFieldComponent>(),
      );
      expect(
        TextFieldFactory.create(
          const TextFieldViewModel(type: TextFieldType.email),
        ),
        isA<StandardTextFieldComponent>(),
      );
    });

    test('ActivityTileFactory', () {
      const base = (kind: ActivityKind.exam, title: 'Prova');
      expect(
        ActivityTileFactory.create(
          ActivityTileViewModel(
            type: ActivityTileType.check,
            kind: base.kind,
            title: base.title,
          ),
        ),
        isA<CheckActivityTileComponent>(),
      );
    });

    test('StateViewFactory', () {
      expect(
        StateViewFactory.create(const StateViewViewModel.loading()),
        isA<LoadingStateComponent>(),
      );
    });
  });

  testWidgets('o botão delega o clique para a ViewModel', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        ButtonFactory.create(
          ButtonViewModel(
            type: ButtonType.primary,
            label: 'Entrar',
            onPressed: () => taps++,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Entrar'));
    expect(taps, 1);
  });

  testWidgets('a senha começa oculta e o olho mostra', (tester) async {
    await tester.pumpWidget(
      _host(
        TextFieldFactory.create(
          const TextFieldViewModel(type: TextFieldType.password, label: 'Senha'),
        ),
      ),
    );
    expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isTrue);
    await tester.tap(find.byTooltip('Mostrar senha'));
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField)).obscureText,
      isFalse,
    );
  });

  for (final dark in [false, true]) {
    testWidgets('componentes renderizam no tema ${dark ? 'escuro' : 'claro'}', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          dark: dark,
          SingleChildScrollView(
            child: Column(
              children: [
                SegmentedFactory.create(
                  const SegmentedViewModel(
                    segments: ['A', 'B'],
                    selectedIndex: 0,
                  ),
                ),
                SubjectCardFactory.create(
                  const SubjectCardViewModel(
                    name: 'Mobile II',
                    initials: 'M2',
                    tone: AppTone.primary,
                    averageLabel: '9,1',
                    status: BadgeViewModel(label: 'Aprovada'),
                    absences: 2,
                    maxAbsences: 18,
                  ),
                ),
                ActivityTileFactory.create(
                  const ActivityTileViewModel(
                    type: ActivityTileType.due,
                    kind: ActivityKind.assignment,
                    title: 'Projeto final',
                    dueLabel: 'Em 5 dias',
                  ),
                ),
                ToggleFactory.create(
                  const ToggleViewModel(label: 'Tema escuro', value: true),
                ),
                AvatarFactory.create(const AvatarViewModel(name: 'Emilly Reis')),
              ],
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Mobile II'), findsOneWidget);
      expect(find.text('ER'), findsOneWidget);
    });
  }
}
