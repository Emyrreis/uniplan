# uniplan_design_system

Tokens, tema (claro e escuro) e componentes do app UniPlan.

## Usando

```dart
import 'package:uniplan_design_system/uniplan_design_system.dart';

MaterialApp(
  theme: AppTheme.light(),
  darkTheme: AppTheme.dark(),
  themeMode: mode,
  ...
);

// Na View, sempre pela Factory, com a ViewModel vinda da ViewModel da tela:
ButtonFactory.create(viewModel.submitButton);
```

## Paleta

| Token | Claro | Escuro | Uso |
|---|---|---|---|
| `primary` | `#5B4BDB` | `#8B7CF6` | ação principal, item ativo |
| `accent` | `#E8762C` | `#F29A5B` | prazo próximo, "+1 falta", botão flutuante |
| `success` | `#1F9E8F` | `#3CC2B1` | terceira cor de disciplina, listas |
| `warning` | `#B4461A` | `#F08A5D` | "Em risco" |
| `background` | `#F6F5FB` | `#14131F` | folha de conteúdo |
| `surface` | `#ECE9FB` | `#22203A` | campos, cards, barra de navegação |
| `header` | `#5B4BDB` | `#2A2360` | faixa do topo |

Fonte: **Poppins** (300–700), empacotada em `fonts/`.

Os componentes recebem um **`AppTone`** (`primary`, `accent`, `success`,
`warning`, `neutral`, `ink`) e o tema resolve o par fundo/texto certo:
`context.semanticColors.tone(AppTone.accent)`.

## Componentes

Cada pasta em `lib/src/components/` tem `*_view_model.dart`,
`*_factory.dart` e `*_component.dart`.

| Componente | Tipos (a Factory escolhe) | Interação delegada |
|---|---|---|
| **Button** | primary · secondary · accent · text · icon | `onPressed` (+ `loading`, `enabled`) |
| **TextField** | text · email · password · number · multiline · search | `onChanged`, `onSubmitted` |
| **Segmented** | — | `onSelected(index)` |
| **ChipGroup** | escolha única · várias escolhas | `onToggled(index)` + `toggled()` |
| **Checkbox** | — | `onChanged(bool)` |
| **Toggle** (linha com switch) | — | `onChanged(bool)` |
| **Badge** | por `AppTone` | — |
| **ProgressBar** | labeled · thin | — |
| **Avatar** | foto ou iniciais | — |
| **SectionHeader** | com ou sem link | `onAction` |
| **StatCard** | onHeader · card | botão opcional (`action`) |
| **SubjectCard** | — | `onTap` |
| **ClassCard** | — | `onTap` (mostra horário · bloco · sala) |
| **ScheduleTile** | — | `onTap`; `matches(query)` para a busca de salas |
| **ActivityTile** | due · grade · check | `onTap`, `onCheckedChanged` |
| **NavBar** | — | `onSelected(index)` |
| **SheetScaffold** | com ou sem barra / botão flutuante | botões do topo e flutuante |
| **StateView** | loading · empty · error | `onAction` ("Tentar de novo") |

Componentes compostos reaproveitam os outros **pela Factory**: o
`SubjectCard` usa `BadgeFactory` e `ProgressBarFactory`, o `StatCard` usa
`ButtonFactory`, e o `ActivityTile.check` usa `CheckboxFactory`.

## Sample app

`example/` é a galeria: Fundamentos (cores, tipografia e tons), Botões,
Campos, Seleção, Cards e tiles, Estados, a tela "Hoje" montada só com
componentes e a tela "Onde é minha aula?" (salas por dia da semana). O botão no topo de todas as páginas alterna o tema
claro/escuro.
