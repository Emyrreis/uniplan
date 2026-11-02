# API do UniPlan — contrato (v1)

Contrato entre o app e o servidor. O servidor ainda vai ser construído
(mockado primeiro, como na aula), mas o app já pode ser escrito contra este
documento: se algo mudar, muda aqui primeiro.

As convenções seguem o contrato do `carteira-digital`, o mesmo formato que o
`ApiClient` do core já entende.

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
| 409 | `conflict` | ex.: excluir disciplina que ainda tem atividades | `UnknownError` |
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
  "avatarUrl": null,
  "createdAt": "2026-10-30T12:00:00Z"
}
```

| Campo | Tipo | Observação |
|---|---|---|
| `course` | string \| null | nome do curso |
| `period` | int \| null | período atual (1–12) |
| `term` | string | semestre letivo atual, `AAAA/1` ou `AAAA/2` |

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

---

## 3. Endpoints

| Método | Caminho | Cena do app que usa |
|---|---|---|
| GET | `/health` | — (checagem manual) |
| POST | `/auth/login` | Login |
| POST | `/auth/logout` | Perfil |
| GET | `/me` | Perfil |
| PUT | `/me` | Perfil |
| GET | `/overview` | Hoje |
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

A Splash não chama a API: ela só lê a sessão salva no aparelho e decide entre Login e Hoje.

---

### GET /health

Sem token.

**200**
```json
{ "status": "ok" }
```

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
  "user": { /* User */ }
}
```

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

### POST /auth/logout

Invalida o token atual.

**204** sem corpo. Se o token já for inválido, também responde **204**: sair nunca falha para o usuário.

---

### GET /me

**200** → `User`

---

### PUT /me

Atualiza só os dados de perfil. O e-mail não muda por aqui.

**Request**
```json
{
  "name": "Emilly Reis",
  "course": "Sistemas de Informação",
  "period": 5,
  "avatarUrl": null
}
```

**200** → `User` atualizado

**422**
```json
{
  "error": {
    "code": "validation_failed",
    "message": "Alguns campos estão inválidos.",
    "fields": { "name": "O nome é obrigatório.", "period": "Use um período de 1 a 12." }
  }
}
```

---

### GET /overview

Tudo o que a Home "Hoje" mostra, numa chamada só.

**Query**

| Parâmetro | Obrigatório | Exemplo | Padrão |
|---|---|---|---|
| `date` | não | `2026-10-30` | hoje (no fuso do servidor) |

**200** → `Overview`

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
| `schedule` | não (`[]`) | `start` < `end`, `weekday` de 1 a 7, `block` e `room` obrigatórios em cada aula (1–20 caracteres) |
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
| `dueAt` | sim | data e hora ISO 8601 |
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
| Login | `ServerLogin.fetchLogin()` | `POST /auth/login` |
| Hoje | `ServerToday.fetchOverview()` | `GET /overview` |
| Onde é minha aula? | `ServerRooms.fetchSchedule(weekday, query)` | `GET /schedule?weekday=&q=` |
| Disciplinas | `ServerSubjects.fetchSubjects()` | `GET /subjects` |
| Detalhe da disciplina | `ServerSubjectDetail` | `GET /subjects/:id` + `GET /activities?subjectId=` em paralelo; `POST /subjects/:id/absences` |
| Atividades | `ServerActivities` | `GET /activities?status=&q=`; `PATCH /activities/:id` |
| Nova atividade | `ServerActivityForm` | `GET /subjects` (lista de disciplinas); `POST /activities` |
| Perfil | `ServerProfile` | `GET /me`, `PUT /me`, `POST /auth/logout` |

Cada `Server*` é uma interface (protocolo) com duas implementações: a **mock**, com dados em memória para desenvolver sem servidor, e a **real**, que chama a API. Trocar uma pela outra é só mudar a linha da Factory da cena.
