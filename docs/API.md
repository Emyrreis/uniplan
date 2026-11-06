# API do UniPlan — contrato (v1.1)

Contrato entre o app e o servidor. O servidor ainda vai ser construído
(mockado primeiro, como na aula), mas o app já pode ser escrito contra este
documento: se algo mudar, muda aqui primeiro.

As convenções seguem o contrato do `carteira-digital`, o mesmo formato que o
`ApiClient` do core já entende.

**Mudanças na v1.1:** notificações (`/notifications`), datas do semestre no usuário, cadastro e "esqueci minha senha", `expiresAt` no login, fuso horário no `/overview` e regras de validação explícitas.

---

## 1. Convenções

### Endereço

| Onde o app roda | Base URL |
|---|---|
| Emulador Android | `http://10.0.2.2:8080` |
| Desktop / navegador / simulador iOS | `http://localhost:8080` |

### Cabeçalhos

| Cabeçalho | Quando | Valor |
|---|---|---|
| `Accept` | sempre | `application/json` |
| `Content-Type` | requisições com corpo | `application/json; charset=utf-8` |
| `Authorization` | todas, menos `/health` e `/auth/login` | `Bearer <token>` |

### Formatos

- **Datas e horas:** ISO 8601 em UTC, ex.: `"2026-11-04T23:59:00Z"`. O app converte para o fuso local na hora de mostrar.
- **Datas sem hora:** `YYYY-MM-DD`, ex.: `"2026-10-30"`.
- **Horário de aula:** `HH:mm` no horário local, ex.: `"19:00"`.
- **Notas:** número de 0 a `maxGrade` (padrão 10), com até 2 casas decimais. As médias são devolvidas de 0 a 10.
- **IDs:** strings com prefixo, ex.: `"sub_01"`, `"act_07"`, `"usr_01"`.
- **Campos opcionais** vêm como `null`, nunca ausentes.

### Paginação

Listas paginadas aceitam `page` (começa em 1) e `pageSize` (padrão 20, máx. 100) e respondem assim:

```json
{
  "items": [ ... ],
  "page": 1,
  "pageSize": 20,
  "total": 42
}
```

### Erros

Toda resposta de erro tem o mesmo corpo:

```json
{
  "error": {
    "code": "validation_failed",
    "message": "Alguns campos estão inválidos.",
    "fields": { "title": "Informe o título." }
  }
}
```

`fields` só aparece no 422.

| Status | `code` | Quando | Erro no app (`AppError`) |
|---|---|---|---|
| 400 | `bad_request` | JSON malformado ou parâmetro com formato errado | `UnknownError` |
| 401 | `unauthorized` | sem token ou token desconhecido | `UnauthorizedError` |
| 401 | `invalid_credentials` | e-mail ou senha errados no login | `UnauthorizedError(invalidCredentials: true)` |
| 401 | `token_expired` | token vencido | `UnauthorizedError(expired: true)` |
| 404 | `not_found` | o recurso não existe (ou não é do usuário) | `NotFoundError` |
| 409 | `conflict` | e-mail já cadastrado; excluir disciplina que ainda tem atividades | `UnknownError` |
| 422 | `validation_failed` | corpo com campos inválidos | `ValidationError(fields)` |
| 500 | `internal_error` | falha no servidor | `ServerError` |

Ao receber qualquer **401** fora do login, o app limpa a sessão salva e volta para o Login, igual ao `carteira-digital`.

---

## 2. Modelos

### User

```json
{
  "id": "usr_01",
  "name": "Emilly Reis",
  "email": "emilly@projetofinal.dev",
  "course": "Sistemas de Informação",
  "period": 5,
  "term": "2026/2",
  "termStartsOn": "2026-08-03",
  "termEndsOn": "2026-12-12",
  "avatarUrl": null,
  "createdAt": "2026-10-30T12:00:00Z"
}
```

| Campo | Tipo | Observação |
|---|---|---|
| `course` | string \| null | nome do curso |
| `period` | int \| null | período atual (1–12) |
| `term` | string | semestre letivo atual, `AAAA/1` ou `AAAA/2` |
| `termStartsOn` / `termEndsOn` | data \| null | início e fim do semestre; é daqui que sai o progresso da Home. `null` enquanto o aluno não informar |

### Subject (disciplina)

```json
{
  "id": "sub_01",
  "name": "Mobile II",
  "initials": "M2",
  "professor": "Prof. Nome",
  "color": "primary",
  "schedule": [
    { "weekday": 3, "start": "19:00", "end": "20:40", "block": "C", "room": "Lab 3", "floor": "Térreo" },
    { "weekday": 5, "start": "19:00", "end": "20:40", "block": "C", "room": "Lab 3", "floor": "Térreo" }
  ],
  "passingGrade": 7.0,
  "maxAbsences": 18,
  "absences": 2,
  "average": 9.1,
  "pendingCount": 1,
  "status": "approved",
  "createdAt": "2026-08-07T12:00:00Z"
}
```

| Campo | Tipo | Observação |
|---|---|---|
| `initials` | string | 1–3 caracteres; se não for enviado, o servidor gera a partir do nome |
| `color` | enum | `primary` \| `accent` \| `success` \| `ink`, os mesmos nomes do `AppTone` do design system |
| `schedule[]` | lista | uma entrada por aula na semana; cada aula pode ser num lugar diferente |
| `schedule[].weekday` | int | 1 = segunda … 7 = domingo |
| `schedule[].block` | string | identificador do bloco: `"A"`, `"C"` (o app mostra "Bloco C") |
| `schedule[].room` | string | `"Sala 204"`, `"Lab 3"` |
| `schedule[].floor` | string \| null | `"Térreo"`, `"2º andar"` |
| `average` | number \| null | **calculada** pelo servidor; `null` sem nenhuma nota |
| `pendingCount` | int | **calculado**: atividades ainda não entregues |
| `status` | enum | **calculado**: `ongoing` \| `approved` \| `at_risk` |

**Regras calculadas** (o app não recalcula, só mostra):
- `average` = Σ(nota ÷ maxGrade × 10 × peso) ÷ Σ(peso), considerando só as atividades com nota.
- `status = at_risk` quando `absences ≥ 75%` de `maxAbsences` **ou** quando `average < passingGrade`.
- `status = approved` quando não há atividade sem nota e `average ≥ passingGrade`.
- Nos outros casos, `status = ongoing`.

### Activity (atividade)

```json
{
  "id": "act_07",
  "subjectId": "sub_01",
  "subjectName": "Mobile II",
  "title": "Projeto final",
  "kind": "assignment",
  "dueAt": "2026-11-04T23:59:00Z",
  "weight": 2,
  "maxGrade": 10,
  "grade": null,
  "delivered": false,
  "deliveredAt": null,
  "note": null,
  "status": "pending",
  "createdAt": "2026-10-23T22:10:00Z"
}
```

| Campo | Tipo | Observação |
|---|---|---|
| `kind` | enum | `exam` (Prova) \| `assignment` (Trabalho) \| `exercise` (Lista) \| `presentation` (Seminário), o mesmo que o `ActivityKind` do design system |
| `weight` | number | maior que 0, padrão 1 |
| `maxGrade` | number | maior que 0, padrão 10 |
| `grade` | number \| null | de 0 a `maxGrade` |
| `status` | enum | **calculado**: `pending` (não entregue e no prazo), `late` (não entregue e com prazo vencido), `delivered` (entregue e sem nota), `graded` (com nota) |

### Overview (resumo da Home "Hoje")

```json
{
  "date": "2026-10-30",
  "overallAverage": 8.2,
  "pendingCount": 4,
  "unreadNotifications": 3,
  "semester": {
    "term": "2026/2",
    "startsOn": "2026-08-03",
    "endsOn": "2026-12-12",
    "progress": 0.68,
    "weeksTotal": 19,
    "weeksLeft": 6
  },
  "classesToday": [
    {
      "subjectId": "sub_01",
      "subjectName": "Mobile II",
      "color": "primary",
      "start": "19:00",
      "end": "20:40",
      "block": "C",
      "room": "Lab 3",
      "floor": "Térreo"
    }
  ],
  "upcoming": [ /* até 5 Activity não entregues, por dueAt crescente */ ]
}
```

| Campo | Observação |
|---|---|
| `unreadNotifications` | número do contador do sino |
| `semester` | `null` quando o usuário ainda não informou as datas do semestre (a Home esconde a barra de progresso) |
| `semester.progress` | de 0 a 1: dias passados ÷ dias do semestre |

### Notification

```json
{
  "id": "ntf_12",
  "kind": "due_soon",
  "title": "Prazo amanhã",
  "text": "Prova 2 de Inteligência Artificial é amanhã às 08:00.",
  "read": false,
  "createdAt": "2026-10-30T13:00:00Z",
  "target": { "type": "activity", "id": "act_03" }
}
```

| Campo | Tipo | Observação |
|---|---|---|
| `kind` | enum | `due_soon` \| `grade_posted` \| `absence_risk` \| `class_today`, que definem o ícone e a cor no pop-up |
| `target` | objeto \| null | para onde o toque leva: `{ "type": "activity" \| "subject", "id": "..." }` |

**Quando o servidor cria cada uma** (o app só lista):
- `due_soon`: atividade não entregue com `dueAt` nas próximas 24 h (uma vez por atividade).
- `grade_posted`: quando uma nota é lançada pelo `PATCH /activities/:id`.
- `absence_risk`: quando as faltas de uma disciplina passam de 75% de `maxAbsences` (uma vez por disciplina).
- `class_today`: no começo do dia, uma por aula do dia, com bloco e sala no texto.

---

## 3. Endpoints

| Método | Caminho | Cena do app que usa |
|---|---|---|
| GET | `/health` | — (checagem manual) |
| POST | `/auth/register` | Cadastro |
| POST | `/auth/login` | Login |
| POST | `/auth/forgot-password` | Login ("Esqueci minha senha") |
| POST | `/auth/logout` | Perfil |
| GET | `/me` | Perfil |
| PUT | `/me` | Perfil |
| GET | `/overview` | Hoje |
| GET | `/notifications` | Hoje (pop-up do sino) |
| PATCH | `/notifications/:id` | Hoje (tocar numa notificação) |
| POST | `/notifications/read-all` | Hoje ("Marcar todas como lidas") |
| GET | `/schedule` | Onde é minha aula? (salas da semana) |
| GET | `/subjects` | Disciplinas, Nova atividade (lista de disciplinas) |
| POST | `/subjects` | Nova disciplina |
| GET | `/subjects/:id` | Detalhe da disciplina |
| PUT | `/subjects/:id` | Editar disciplina |
| DELETE | `/subjects/:id` | Editar disciplina |
| POST | `/subjects/:id/absences` | Detalhe da disciplina (+1 falta) |
| GET | `/activities` | Atividades, Detalhe da disciplina |
| POST | `/activities` | Nova atividade |
| GET | `/activities/:id` | Detalhe da atividade |
| PUT | `/activities/:id` | Editar atividade |
| PATCH | `/activities/:id` | Marcar entregue / lançar nota |
| DELETE | `/activities/:id` | Detalhe da atividade |

A Splash não chama a API: ela só lê a sessão salva no aparelho (e o `expiresAt`) e decide entre Login e Hoje. O tema claro/escuro também não passa pela API: é uma preferência guardada no aparelho.

---

### GET /health

Sem token.

**200**
```json
{ "status": "ok" }
```

---

### POST /auth/register

Sem token. Cria a conta e já devolve a sessão, como o login.

**Request**
```json
{
  "name": "Emilly Reis",
  "email": "emilly@projetofinal.dev",
  "password": "final2026"
}
```

| Campo | Validação |
|---|---|
| `name` | 2–60 caracteres |
| `email` | e-mail válido, ainda não cadastrado |
| `password` | mínimo de 6 caracteres |

**201**: mesmo corpo do `200` do login (`token`, `expiresAt`, `user`).

**409** `conflict`
```json
{ "error": { "code": "conflict", "message": "Já existe uma conta com este e-mail." } }
```

**422** `validation_failed` com `fields` por campo.

---

### POST /auth/login

Sem token.

**Request**
```json
{ "email": "emilly@projetofinal.dev", "password": "final2026" }
```

**200**
```json
{
  "token": "tk_9f2c1a...",
  "expiresAt": "2026-12-06T23:00:00Z",
  "user": { /* User */ }
}
```

O token vale 30 dias. O app guarda `expiresAt` na sessão e, se a data já passou, a Splash manda direto para o Login. Se o servidor recusar o token antes disso, ele responde `401 token_expired`, e o app faz o mesmo.

**401** `invalid_credentials`
```json
{ "error": { "code": "invalid_credentials", "message": "E-mail ou senha incorretos." } }
```

**422** `validation_failed`
```json
{
  "error": {
    "code": "validation_failed",
    "message": "Preencha e-mail e senha.",
    "fields": { "email": "Informe o e-mail.", "password": "Informe a senha." }
  }
}
```

> Usuário de teste do servidor mockado: `emilly@projetofinal.dev` / `final2026`.

---

### POST /auth/forgot-password

Sem token. Pede um e-mail de redefinição de senha.

**Request**
```json
{ "email": "emilly@projetofinal.dev" }
```

**204** sem corpo, **sempre**, mesmo que o e-mail não exista. Assim ninguém descobre quais e-mails têm conta. O app mostra "Se o e-mail estiver cadastrado, você vai receber as instruções."

**422** só quando o e-mail tem formato inválido.

> No servidor mockado, o envio é só simulado; a redefinição em si fica para uma versão futura.

---

### POST /auth/logout

Invalida o token atual.

**204** sem corpo. Se o token já for inválido, também responde **204**: sair nunca falha para o usuário.

---

### GET /me

**200** → `User`

---

### PUT /me

Atualiza os dados de perfil e o semestre atual. O e-mail não muda por aqui.

**Request**
```json
{
  "name": "Emilly Reis",
  "course": "Sistemas de Informação",
  "period": 5,
  "term": "2026/2",
  "termStartsOn": "2026-08-03",
  "termEndsOn": "2026-12-12",
  "avatarUrl": null
}
```

| Campo | Validação |
|---|---|
| `name` | obrigatório, 2–60 caracteres |
| `period` | `null` ou de 1 a 12 |
| `term` | formato `AAAA/1` ou `AAAA/2` |
| `termStartsOn` / `termEndsOn` | as duas juntas ou nenhuma; início antes do fim |

**200** → `User` atualizado

**422**
```json
{
  "error": {
    "code": "validation_failed",
    "message": "Alguns campos estão inválidos.",
    "fields": {
      "name": "O nome é obrigatório.",
      "termEndsOn": "O fim do semestre precisa ser depois do início."
    }
  }
}
```

---

### GET /overview

Tudo o que a Home "Hoje" mostra, numa chamada só.

**Query**

| Parâmetro | Obrigatório | Exemplo | Padrão |
|---|---|---|---|
| `tz` | sim | `America/Araguaina` | fuso do aparelho; define o que é "hoje" e os horários das aulas do dia |
| `date` | não | `2026-10-30` | hoje no fuso `tz` |

**400** `bad_request` quando `tz` falta ou não é um fuso válido.

**200** → `Overview`

---

### GET /notifications

As notificações do pop-up do sino, das mais novas para as mais antigas.

**Query**

| Parâmetro | Exemplo | Padrão | Observação |
|---|---|---|---|
| `unread` | `true` | — | só as não lidas |
| `page` | `1` | `1` | |
| `pageSize` | `20` | `20` | máx. 100 |

**200**
```json
{
  "items": [ /* Notification */ ],
  "page": 1,
  "pageSize": 20,
  "total": 4
}
```

O servidor guarda as notificações por 30 dias.

---

### PATCH /notifications/:id

Marca uma notificação como lida (ou não lida). O app chama ao tocar nela e depois abre o `target`.

**Request**
```json
{ "read": true }
```

**200** → `Notification` atualizada · **404**

---

### POST /notifications/read-all

"Marcar todas como lidas". Sem corpo.

**200**
```json
{ "updated": 3 }
```

Depois disso, o app zera o contador do sino sem precisar chamar o `/overview` de novo.

---

### GET /schedule

Grade da semana com o local de cada aula. É a tela "Onde é minha aula?": chips de segunda a sábado e busca por disciplina, bloco ou sala.

**Query**

| Parâmetro | Exemplo | Padrão | Observação |
|---|---|---|---|
| `weekday` | `5` | — | 1 a 7; sem ele, vem a semana toda |
| `q` | `bloco c` | — | busca em disciplina, bloco (`"C"` ou `"Bloco C"`) e sala, sem diferenciar maiúsculas e acentos |

**200**
```json
{
  "items": [
    {
      "weekday": 5,
      "start": "19:00",
      "end": "20:40",
      "block": "C",
      "room": "Lab 3",
      "floor": "Térreo",
      "subjectId": "sub_01",
      "subjectName": "Mobile II",
      "professor": "Prof. Nome",
      "color": "primary"
    },
    {
      "weekday": 5,
      "start": "20:50",
      "end": "22:30",
      "block": "C",
      "room": "Sala 204",
      "floor": "2º andar",
      "subjectId": "sub_02",
      "subjectName": "Inteligência Artificial",
      "professor": "Prof. Nome",
      "color": "accent"
    }
  ],
  "page": 1,
  "pageSize": 2,
  "total": 2
}
```

Ordenação: `weekday` e depois `start`, crescentes. A lista é montada a partir do `schedule` das disciplinas, então muda sozinha quando uma disciplina é editada.

**400** `bad_request` quando `weekday` não está entre 1 e 7.

---

### GET /subjects

Disciplinas do semestre atual, em ordem alfabética. A lista é pequena e não é paginada, mas usa o mesmo envelope da paginação para manter o padrão.

**200**
```json
{
  "items": [ /* Subject */ ],
  "page": 1,
  "pageSize": 4,
  "total": 4
}
```

---

### POST /subjects

**Request**
```json
{
  "name": "Mobile II",
  "initials": "M2",
  "professor": "Prof. Nome",
  "color": "primary",
  "schedule": [
    { "weekday": 3, "start": "19:00", "end": "20:40", "block": "C", "room": "Lab 3", "floor": "Térreo" },
    { "weekday": 5, "start": "19:00", "end": "20:40", "block": "C", "room": "Lab 3", "floor": "Térreo" }
  ],
  "passingGrade": 7.0,
  "maxAbsences": 18
}
```

| Campo | Obrigatório | Validação |
|---|---|---|
| `name` | sim | 2–60 caracteres |
| `color` | não (`primary`) | um dos 4 valores |
| `schedule` | não (`[]`) | `start` < `end`, `weekday` de 1 a 7, `block` e `room` obrigatórios em cada aula (1–20 caracteres). Aulas **da mesma disciplina** no mesmo dia não podem se sobrepor (422). Entre disciplinas diferentes, a sobreposição é permitida (choque de horário é decisão do aluno) |
| `passingGrade` | não (7.0) | de 0 a 10 |
| `maxAbsences` | não (0 = sem limite) | inteiro ≥ 0 |

**201** → `Subject` criada (`absences: 0`, `average: null`, `status: "ongoing"`)

**422** com `fields` por campo.

---

### GET /subjects/:id

**200** → `Subject`

**404** `not_found`
```json
{ "error": { "code": "not_found", "message": "Disciplina não encontrada." } }
```

---

### PUT /subjects/:id

Mesmo corpo do POST. Substitui todos os campos editáveis.

**200** → `Subject` atualizada · **404** · **422**

---

### DELETE /subjects/:id

**204** sem corpo.

**409** `conflict` quando a disciplina ainda tem atividades:
```json
{ "error": { "code": "conflict", "message": "Exclua as atividades desta disciplina primeiro." } }
```

Com `?force=true`, exclui a disciplina junto com as atividades dela e responde **204**.

---

### POST /subjects/:id/absences

Soma (ou desfaz) faltas. É o botão "+1 falta" do detalhe da disciplina.

**Request**
```json
{ "delta": 1 }
```

| Campo | Validação |
|---|---|
| `delta` | inteiro diferente de 0; o resultado não pode ficar menor que 0 |

**200** → `Subject` atualizada (com `absences` e `status` recalculados)

**422**
```json
{
  "error": {
    "code": "validation_failed",
    "message": "As faltas não podem ficar negativas.",
    "fields": { "delta": "As faltas não podem ficar negativas." }
  }
}
```

---

### GET /activities

Lista paginada para a aba Atividades e para o detalhe da disciplina.

**Query**

| Parâmetro | Exemplo | Padrão | Observação |
|---|---|---|---|
| `status` | `pending` | `all` | `pending` (inclui `late`) \| `delivered` (inclui `graded`) \| `all`, os mesmos valores do filtro segmentado |
| `subjectId` | `sub_01` | — | só as atividades dessa disciplina |
| `kind` | `exam` | — | um `kind` |
| `from` | `2026-10-30` | — | `dueAt` a partir desse dia |
| `to` | `2026-11-30` | — | `dueAt` até esse dia, inclusive |
| `q` | `simplex` | — | busca no título, sem diferenciar maiúsculas e acentos |
| `page` | `1` | `1` | |
| `pageSize` | `20` | `20` | máx. 100 |

Ordenação: `dueAt` crescente (o mais urgente primeiro). O app agrupa por dia para os cabeçalhos ("Amanhã, sábado 31/10").

**200**
```json
{
  "items": [ /* Activity */ ],
  "page": 1,
  "pageSize": 20,
  "total": 7
}
```

**400** `bad_request` para `status` ou datas com formato inválido.

---

### POST /activities

**Request**
```json
{
  "subjectId": "sub_01",
  "title": "Projeto final",
  "kind": "assignment",
  "dueAt": "2026-11-04T23:59:00Z",
  "weight": 2,
  "maxGrade": 10,
  "note": null
}
```

| Campo | Obrigatório | Validação |
|---|---|---|
| `subjectId` | sim | disciplina existente do usuário |
| `title` | sim | 2–80 caracteres |
| `kind` | sim | um dos 4 valores |
| `dueAt` | sim | data e hora ISO 8601. Datas no passado **são permitidas**, para registrar atividades que já aconteceram |
| `weight` | não (1) | > 0 |
| `maxGrade` | não (10) | > 0 |
| `note` | não | até 500 caracteres |

**201** → `Activity` criada (`delivered: false`, `grade: null`)

**422**
```json
{
  "error": {
    "code": "validation_failed",
    "message": "Alguns campos estão inválidos.",
    "fields": {
      "title": "Informe o título.",
      "subjectId": "Escolha uma disciplina."
    }
  }
}
```

---

### GET /activities/:id

**200** → `Activity` · **404**

---

### PUT /activities/:id

Mesmo corpo do POST. Substitui todos os campos editáveis. `delivered` e `grade` não mudam por aqui.

**200** → `Activity` · **404** · **422**

---

### PATCH /activities/:id

Atualização parcial: só os campos enviados mudam. É usado pela caixa "entregue" da lista e por "lançar nota".

**Request** (marcar como entregue)
```json
{ "delivered": true }
```

**Request** (lançar nota)
```json
{ "grade": 8.6 }
```

| Campo | Validação |
|---|---|
| `delivered` | booleano. `true` grava `deliveredAt` com o horário atual; `false` apaga `deliveredAt` |
| `grade` | `null` ou de 0 a `maxGrade`. Lançar uma nota também marca a atividade como entregue |

**200** → `Activity` atualizada (com `status` recalculado). A média e o status da disciplina também mudam; o app recarrega a disciplina se estiver aberta.

**422**
```json
{
  "error": {
    "code": "validation_failed",
    "message": "A nota precisa estar entre 0 e 10.",
    "fields": { "grade": "A nota precisa estar entre 0 e 10." }
  }
}
```

---

### DELETE /activities/:id

**204** sem corpo · **404**

Na tela, segue o fluxo do `carteira-digital`: exclui, faz `pop(true)` e mostra "Atividade excluída." A tela anterior recebe `true` e recarrega.

---

## 4. Como as cenas usam a API

| Cena | Server (protocolo) | Chamadas |
|---|---|---|
| Splash | `ServerSplash.hasSession()` | nenhuma; lê o storage |
| Login | `ServerLogin.fetchLogin()`, `requestPasswordReset()` | `POST /auth/login`, `POST /auth/forgot-password` |
| Cadastro | `ServerRegister.register()` | `POST /auth/register` |
| Hoje | `ServerToday.fetchOverview()` | `GET /overview?tz=` |
| Hoje: pop-up do sino | `ServerNotifications` | `GET /notifications`, `PATCH /notifications/:id`, `POST /notifications/read-all` |
| Onde é minha aula? | `ServerRooms.fetchSchedule(weekday, query)` | `GET /schedule?weekday=&q=` |
| Disciplinas | `ServerSubjects.fetchSubjects()` | `GET /subjects` |
| Detalhe da disciplina | `ServerSubjectDetail` | `GET /subjects/:id` + `GET /activities?subjectId=` em paralelo; `POST /subjects/:id/absences` |
| Atividades | `ServerActivities` | `GET /activities?status=&q=`; `PATCH /activities/:id` |
| Nova atividade | `ServerActivityForm` | `GET /subjects` (lista de disciplinas); `POST /activities` |
| Perfil | `ServerProfile` | `GET /me`, `PUT /me` (dados e semestre), `POST /auth/logout` |

Cada `Server*` é uma interface (protocolo) com duas implementações: a **mock**, com dados em memória para desenvolver sem servidor, e a **real**, que chama a API. Trocar uma pela outra é só mudar a linha da Factory da cena.