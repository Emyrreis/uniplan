# Protótipo das telas — UniPlan

Protótipo feito no canvas de design, em tamanho de celular (390 × 844).
As imagens desta pasta foram geradas a partir dele: as claras ficam aqui e as
do **tema escuro**, com os mesmos nomes, em [`escuro/`](escuro/).

| # | Tela | Arquivo | O que mostra |
|---|---|---|---|
| 1 | Login | `01-login.png` | logo, e-mail, senha com "mostrar/ocultar", Entrar, "Esqueci minha senha" com confirmação, link "Criar conta" |
| 2 | Hoje (Home) | `02-hoje.png` | média geral, pendências, progresso do semestre, aulas de hoje com bloco e sala, próximas entregas |
| 3 | Notificações | `03-notificacoes.png` | pop-up do sino: prazo amanhã, nota lançada, alerta de faltas, aula hoje; marcar todas como lidas |
| 4 | Onde é minha aula? | `04-salas.png` | chips de Seg a Sáb, busca por disciplina/bloco/sala, cards com horário, bloco, sala e andar |
| 5 | Disciplinas | `05-disciplinas.png` | cards com sigla, professor, média, situação e barra de faltas |
| 6 | Detalhe da disciplina | `06-disciplina.png` | média atual, faltas com "+1 falta", atividades com peso e nota |
| 7 | Atividades | `07-atividades.png` | filtro Pendentes/Entregues/Todas, busca, lista por dia, caixa "entregue", botão + |
| 8 | Nova atividade | `08-nova-atividade.png` | título, disciplina, tipo, entrega, peso, observação |
| 9 | Perfil | `09-perfil.png` | avatar, curso e período, semestre atual com datas, Editar perfil, tema escuro, sair com confirmação |
| 10 | Cadastro | `10-cadastro.png` | logo, nome, e-mail, senha com regra de 6 caracteres, confirmar senha, validação ao digitar, "Criar conta" só habilitado com tudo válido |
| 11 | Editar perfil | `11-editar-perfil.png` | foto (galeria, câmera ou remover), nome, e-mail só leitura, curso, período, semestre letivo, datas do semestre, Salvar só com tudo válido |

## Fluxo

```
Splash ──sessão salva──▶ Hoje
   └──sem sessão──▶ Login ──▶ Hoje
Login ─ "Criar conta" ─▶ Cadastro ──▶ Hoje (o cadastro já devolve a sessão)
Login ─ "Esqueci minha senha" ─▶ mensagem de confirmação na própria tela
Hoje ─ sino ─▶ Notificações
Hoje ─ "Ver salas da semana" / card da aula ─▶ Onde é minha aula?
Barra inferior: Hoje · Disciplinas · Atividades · Perfil
Disciplinas ─▶ Detalhe da disciplina ─ "+ Adicionar" ─▶ Nova atividade
Atividades ─ botão + ─▶ Nova atividade
Perfil ─ Editar perfil ─▶ Editar perfil ─ Salvar ─▶ Perfil
Perfil ─ Sair da conta ─▶ "Sair da conta?" ─ Sair ─▶ Login (sessão apagada)
```

## Paleta

Violeta `#5B4BDB` (principal) · Laranja `#E8762C` (prazos e alertas) ·
Verde-azulado `#1F9E8F` · Laranja escuro `#B4461A` (em risco) ·
Fundo `#F6F5FB` · Superfície `#ECE9FB` · Texto `#1C1B2E` · Fonte Poppins.
O tema escuro está definido no design system (`AppColors.dark`).

## Logo

Símbolo: o **"U"** de UniPlan com o braço direito mais curto e um **ponto
laranja** em cima, o "marcador" do plano (juntos, também formam "Ui", de *Uni*).
Arquivos em `docs/marca/` e componente `LogoFactory` no design system.

| Onde | Arquivo | Cores |
|---|---|---|
| Sobre a faixa violeta (Login, Cadastro) | `uniplan-logo-header.svg` | quadrado branco, "U" violeta, ponto laranja |
| Fundo claro / ícone | `uniplan-logo.svg` | quadrado violeta, "U" branco, ponto laranja |

## Estados que dá para testar no canvas (Play)

- **Login:** mostrar/ocultar senha; "Esqueci minha senha" mostra a confirmação. A mensagem de erro "E-mail ou senha incorretos." é ligada pelo ajuste *showError* do canvas.
- **Editar perfil:** toque na foto e escolha uma imagem do computador; apague o nome ou coloque o fim do semestre antes do início para ver os erros.
- **Perfil:** "Sair da conta" abre a confirmação; "Sair" volta para o Login.
- **Tema escuro em todas as telas:** ligue o switch *Tema escuro* no Perfil e navegue. A escolha fica salva e as outras telas abrem escuras. No canvas, cada tela também tem o ajuste *dark* (Tweaks) para ver a versão escura sem usar o Play.
- **Cadastro:** digite um nome com 1 letra, um e-mail sem "@", `emilly@projetofinal.dev` (e-mail já cadastrado) ou senhas diferentes para ver cada erro.
