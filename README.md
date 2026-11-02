# UniPlan — projeto final de Mobile II

Organizador acadêmico para estudante de faculdade: disciplinas, provas e
trabalhos com prazo, notas, média por matéria e controle de faltas, tudo
num só lugar.

## A ideia

**Problema.** As informações do semestre ficam espalhadas: o horário está
numa foto, os prazos no grupo da turma, as notas no portal e as faltas na
cabeça. O aluno só descobre que está em risco quando já é tarde.

**Solução.** Um app que responde a três perguntas assim que é aberto:
o que eu tenho hoje, o que vence logo e como estou em cada matéria.

**Funcionalidades**
- **Hoje:** aulas do dia (com bloco e sala), próximas entregas, média geral, número de pendências e quanto do semestre já passou.
- **Notificações:** pelo sino da Home, com prazos próximos, notas lançadas, alerta de faltas e aulas do dia, além de "Marcar todas como lidas".
- **Onde é minha aula?:** salas da semana escolhendo o dia (Seg a Sáb). Cada aula mostra horário, bloco, sala e andar, com busca por disciplina, bloco ou sala.
- **Disciplinas:** professor, horário, sala, média ponderada calculada, situação (*Em curso / Aprovada / Em risco*) e barra de faltas.
- **Detalhe da disciplina:** atividades com peso e nota, além do botão "+1 falta".
- **Atividades:** agenda agrupada por dia, filtro *Pendentes / Entregues / Todas*, busca e caixa para marcar como entregue.
- **Nova atividade:** título, disciplina, tipo (Prova, Trabalho, Lista ou Seminário), prazo, peso e observação.
- **Perfil:** dados do aluno, semestre atual, tema claro/escuro e sair.

**Telas (protótipo, em `docs/prototipo/`):** Login · Hoje · Notificações · Onde é minha aula? · Disciplinas · Detalhe da disciplina · Atividades · Nova atividade · Perfil.

## Organização

```
uniplan/
├── docs/
│   ├── API.md               # contrato da API: requests, responses e erros
│   └── prototipo/           # telas do protótipo (imagens exportadas do canvas)
└── packages/
    └── design_system/       # uniplan_design_system
        ├── lib/
        │   ├── uniplan_design_system.dart   # exporta tokens, tema e componentes
        │   └── src/
        │       ├── tokens/      # cores, tons, espaçamento, raios, tipografia
        │       ├── theme/       # AppTheme (claro/escuro) + AppSemanticColors
        │       └── components/  # uma pasta por componente (ver abaixo)
        ├── example/         # sample app: galeria de todos os componentes
        ├── fonts/           # Poppins (licença OFL)
        └── test/
```

O app em si vai ser criado na raiz (`lib/`, `packages/core/`), seguindo o
mesmo modelo do `carteira-digital`:

```
lib/
├── main.dart
├── app/                 # dependências, navigatorKey, sessão salva
└── scenes/              # uma pasta por cena, sempre com os mesmos 5 papéis
    ├── splash/          # tela invisível: decide Login ou Hoje
    ├── login/
    ├── today/           # inclui o pop-up de notificações
    ├── rooms/           # "Onde é minha aula?"
    ├── subjects/
    ├── subject_detail/
    ├── activities/
    ├── activity_form/
    └── profile/
```

## Padrões de projeto

### Componentes do design system: ViewModel → Factory → Component → Widget

```
ButtonViewModel(type: primary, label: 'Entrar', loading: true, onPressed: vm.submit)
        │
        ▼
ButtonFactory.create(viewModel)      ← decide qual classe concreta criar
        │
        ▼
PrimaryButtonComponent  (extends ButtonComponent, que é abstrata)
        │
        ▼
FilledButton do Flutter
```

- **ViewModel:** dados e estado do componente (texto, habilitado, carregando) e a função do clique.
- **Factory:** recebe a ViewModel e decide o componente. A tela nunca instancia um componente direto.
- **Component:** constrói o widget do Flutter. As famílias com variações (botões, tiles de atividade, barras, cards de número e estados) têm uma **classe abstrata** base, e cada variação é uma subclasse concreta.
- **Delegate:** o componente não sabe o que o clique faz; ele chama a função que veio na ViewModel.
- **Pouca lógica no `build()`:** valores derivados (ação nula quando desabilitado, porcentagem, itens marcados) são calculados em getters da ViewModel.

### Cenas do app: MVVM com Factory, Server e Coordinator

| Arquivo | Papel |
|---|---|
| `*_factory.dart` | monta a cena: cria Server e Coordinator, injeta no ViewModel e entrega a View |
| `*_view.dart` | só desenha, usando as Factories do design system |
| `*_view_model.dart` | estado e ações da tela; monta as ViewModels dos componentes |
| `server_*.dart` | protocolo (interface) + implementação mock + implementação real |
| `*_coordinator.dart` | navegação para fora da cena |

O sample app já segue esse formato em escala menor: cada página tem a sua
ViewModel, e o `GalleryCoordinator` cuida da navegação e das mensagens.

## Como rodar o sample app

O `example/` tem só o código. Os arquivos de plataforma são gerados uma vez:

```bash
cd packages/design_system/example
flutter create --platforms=android .   # gera a pasta android/ (não mexe em lib/)
flutter pub get
flutter run
```

Para conferir o código e rodar os testes do pacote:

```bash
cd packages/design_system
flutter pub get
flutter analyze
flutter test
```

## Próximos passos

1. Criar o app na raiz com `packages/core` (modelos `User`, `Subject`, `Activity`, `Overview`, o `Result`, o `ApiClient` e os repositórios) a partir do `docs/API.md`.
2. Implementar as cenas na ordem Splash → Login → Hoje → Salas → Disciplinas → Detalhe → Atividades → Nova atividade → Perfil, primeiro com o server **mock**.
3. Construir o servidor seguindo o contrato e trocar o mock pelo real.
