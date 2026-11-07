# Changelog: uniplan_design_system

## 1.1.0 (06/11/2026)

**Novo**
- **Logo** (`LogoFactory`, `LogoViewModel`, tipos `mark` e `full`): símbolo do
  UniPlan desenhado em código, com variação para a faixa do topo (`onHeader`).
  SVGs equivalentes em `docs/marca/`.
- **Sample app:** a página de Fundamentos mostra a logo, e entrou a tela de
  exemplo **Cadastro**, com nome, e-mail, senha e confirmação, validação ao
  digitar e botão habilitado só com tudo válido. As regras são as mesmas do
  `POST /auth/register`.
- **Avatar editável:** com `onEdit`, o avatar vira botão com selo de câmera
  (tela Editar perfil). Sem `onEdit`, nada muda.
- Testes da `LogoFactory`, da logo renderizada nos dois temas e do avatar editável.

**Dados de exemplo** (protótipo e sample app)
- 6 disciplinas do 6º período de Engenharia de Software (Mobile II,
  Desenvolvimento Web, Gerência de Projetos, Inteligência Artificial,
  Otimização para Sistemas e Testes de Software), com professores e aulas
  espalhadas pelos blocos A a D (salas, laboratórios e auditório).
- Mais atividades na agenda: provas, trabalhos, listas e seminário.
- Médias revistas: média geral 9,2. Otimização segue "em risco" pelas faltas (14 de 18).

**Protótipo**
- **Tema escuro em todas as telas:** o switch do Perfil salva a escolha e vale
  para o app inteiro, como o `ValueNotifier<ThemeMode>` do sample app.
- Login com logo (sem a linha de usuário de teste), mostrar/ocultar senha, confirmação do "Esqueci minha senha"
  e link "Criar conta".
- Nova tela **Cadastro** (`docs/prototipo/10-cadastro.png`).
- Perfil: "Engenharia de Software · 6º período", link para **Editar perfil**,
  datas do semestre e confirmação **"Sair da conta?"** antes de voltar ao Login.
- Nova tela **Editar perfil** (`docs/prototipo/11-editar-perfil.png`): foto com
  galeria/câmera/remover (JPG ou PNG até 5 MB), nome, e-mail só leitura, curso,
  período, semestre letivo e datas do semestre, com validação.
- Disciplinas, Atividades, Detalhe e Salas com rolagem para caber os novos dados.
- Imagens de todas as telas nos dois temas: `docs/prototipo/` e `docs/prototipo/escuro/`.

## 1.0.0 (02/11/2026)

- Tokens (cores, tons, espaçamento, raios, tipografia Poppins, durações).
- Tema claro e escuro (`AppTheme`) e cores semânticas (`AppSemanticColors`).
- 18 componentes no padrão ViewModel → Factory → Component: Button, TextField,
  Segmented, ChipGroup, Checkbox, Toggle, Badge, ProgressBar, Avatar,
  SectionHeader, StatCard, SubjectCard, ClassCard, ScheduleTile, ActivityTile,
  NavBar, SheetScaffold e StateView.
- Sample app (galeria) com todas as páginas de componentes e as telas "Hoje" e
  "Onde é minha aula?".
