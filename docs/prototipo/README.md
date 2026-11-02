# Protótipo das telas — UniPlan

Protótipo feito no canvas de design, em tamanho de celular (390 × 844).
As imagens desta pasta foram exportadas de lá.

| # | Tela | Arquivo | O que mostra |
|---|---|---|---|
| 1 | Login | `01-login.png` | e-mail, senha com "mostrar", mensagem de erro, Entrar |
| 2 | Hoje (Home) | `02-hoje.png` | média geral, pendências, progresso do semestre, aulas de hoje com bloco e sala, próximas entregas |
| 3 | Notificações | `03-notificacoes.png` | pop-up do sino: prazo amanhã, nota lançada, alerta de faltas, aula hoje; marcar todas como lidas |
| 4 | Onde é minha aula? | `04-salas.png` | chips de Seg a Sáb, busca por disciplina/bloco/sala, cards com horário, bloco, sala e andar |
| 5 | Disciplinas | `05-disciplinas.png` | cards com sigla, professor, média, situação e barra de faltas |
| 6 | Detalhe da disciplina | `06-disciplina.png` | média atual, faltas com "+1 falta", atividades com peso e nota |
| 7 | Atividades | `07-atividades.png` | filtro Pendentes/Entregues/Todas, busca, lista por dia, caixa "entregue", botão + |
| 8 | Nova atividade | `08-nova-atividade.png` | título, disciplina, tipo, entrega, peso, observação |
| 9 | Perfil | `09-perfil.png` | avatar, dados, semestre atual, tema escuro, sair |


## Fluxo

```
Splash ──sessão salva──▶ Hoje
   └──sem sessão──▶ Login ──▶ Hoje
Hoje ─ sino ─▶ Notificações
Hoje ─ "Ver salas da semana" / card da aula ─▶ Onde é minha aula?
Barra inferior: Hoje · Disciplinas · Atividades · Perfil
Disciplinas ─▶ Detalhe da disciplina ─ "+ Adicionar" ─▶ Nova atividade
Atividades ─ botão + ─▶ Nova atividade
Perfil ─ Sair ─▶ Login
```

## Paleta

Violeta `#5B4BDB` (principal) · Laranja `#E8762C` (prazos e alertas) ·
Verde-azulado `#1F9E8F` · Laranja escuro `#B4461A` (em risco) ·
Fundo `#F6F5FB` · Superfície `#ECE9FB` · Texto `#1C1B2E` · Fonte Poppins.
O tema escuro está definido no design system (`AppColors.dark`).
