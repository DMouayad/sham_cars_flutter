Below is a **single “AI context/design doc” file** you can drop into your repo as something like `GEMINI.md` (or `AI_CONTEXT.md`). It’s written to help *any* AI model (Gemini/Claude/ChatGPT/etc.) quickly understand the project, architecture, and how pieces connect.

You can copy/paste as-is.

---

# `GEMINI.md` — Sham Cars / EV Hub Syria (AI Project Context)

## 0) Project summary (TL;DR)
**Sham Cars** is a mobile-first EV community hub for Syria built with:
- **Frontend:** Flutter mobile app (Arabic-first, supports English)

Core product goals:
1) Build a curated EV catalog (official specs baseline)
2) Enable community knowledge sharing: **Reviews** + **Q&A**
3) Build personalization: **Trending + Recommendations** using tracked events
4) Next: collect **real-world range** data (80% → 20%) by city/season for Syria-relevant insights

Primary locale: Arabic (RTL). English also supported. Mobile UX is priority.

---

## 1) Terminology / Domain mapping
- **Brand / Make**: manufacturer (Tesla, BYD…)
- **Body type**: sedan, SUV, crossover…
- **Vehicle / Trim**:
  - Backend uses `vehicles` table.
  - Mobile API calls these “trims” (`/car-data/trims`). In practice, a “trim” = a specific vehicle variant entry.
- **Community content**:
  - **Review**: rating + text comment
  - **Question**: title + body
  - **Answer**: belongs to a question

---

## 2) System architecture overview

### Mobile (Flutter)
- Uses `go_router` typed routes with a bottom navigation shell.
- Uses **BLoC/Cubit** for state management.
- Uses a `RestClient` + `ResponseCache` for HTTP caching.
- Uses token auth (stored in `ITokensRepository`) + `AuthNotifier` (login status).

---

## 3) Backend data model (high-level)
Key tables:
- `users`
- `vehicles` (official specs + published/featured flags)
- `brands`, `body_types`, `vehicle_images`
- `reviews` (belongs_to user + vehicle; uniqueness: one review per user per vehicle)
- `questions`, `answers`
- `events` (user action logging; `eventable` polymorphic)

Important notes:
- Ransack is used for search/filtering and requires allowlisting:
  - `Vehicle.ransackable_attributes` must include filter fields (e.g., `published`, `seats`, etc.)
- Events are used for: trending/recommendations.

Planned v2 model:
- `usage_reports`: real-world range reports (80%→20%) by city/season/driving mix.

---

## 4) Mobile API contract (current)
Base: `/api/v1`

### Reference data
- `GET /car-data/body-types`
- `GET /car-data/makes`
- `GET /car-data/models`
- `GET /car-data/trims` (supports `search`, `take`, `skip`, filters)
- `GET /car-data/trims/{id}` (trim detail + specs)

### Community
All list endpoints use pagination:
- `take` (page size, default 15)
- `skip` (offset, default 0)

#### Reviews
- `GET /community/reviews`
  - `car_trim_id` optional (global feed supported)
  - returns: `id, user_name, rating, comment, created_at, car_trim_id, car_trim_name, car_model_name`
- `POST /community/reviews` (auth required)
  - `car_trim_id, rating, comment, title? city_code?`

#### Questions
- `GET /community/questions`
  - supports `car_trim_id` optional (trim-scoped Q&A)
  - returns: `id, car_trim_id, trim_name, model_name, user_name, title, body, answers_count, created_at`
- `GET /community/questions/{id}` returns question with answers
- `POST /community/questions` (auth required)
  - backend supports either model/trim; current app uses trim-based posting
- `POST /community/questions/{id}/answers` (auth required)

**Date format note:** API may return `"YYYY-MM-DD HH:MM:SS"`. Flutter normalizes to ISO by replacing space with `T` before `DateTime.parse`.

---

## 5) Flutter app structure & routing
### Routing
Uses typed `go_router` StatefulShellRoute with bottom navigation:
- Home: `/home`
- Vehicles list: `/vehicles`
- Vehicle details: `/vehicles/:id`
- Vehicle community screens:
  - `/vehicles/:id/community/reviews`
  - `/vehicles/:id/community/qa`
- Questions list: `/questions`
- Question details: `/questions/:id`
- Profile/auth routes

### Key screens
- **HomeScreen**: discover vehicles + latest community
- **VehiclesListScreen**: search/filter/pagination (future polish)
- **VehicleDetailsScreen**: sliver header (pinned title), grouped specs, previews for reviews/questions
- **TrimCommunityScreen**: Tabs (Reviews / Q&A), lazy loading, speed dial for posting
- **CommunityScreen**: Global feed of questions+reviews (filters + search + lazy loading)
- **QuestionDetailsScreen**: question + answers + link to related trim (vehicle details)

---

## 6) Flutter state management (Cubits)
### Read/pagination cubits
- `CommunityCubit`
  - Global feed: paginated questions + paginated reviews
  - Local search filters loaded items
  - Lazy loading triggered by scroll
- `TrimCommunityCubit`
  - Paginated trim-scoped reviews/questions
  - `refreshAll()` after posting
- `QuestionDetailsCubit`
  - Loads question + answers
  - `submitAnswer()` posts and refreshes

### Write/actions cubit (shared)
- `CommunityActionsCubit`
  - owns **submitting** question/review
  - used by sheets in both global Community and trim community contexts
  - avoids coupling posting logic to feed/pagination cubits

### Pickers
- `TrimPickerCubit` + `TrimPickerSheet`
  - On-demand trim selection
  - Supports pagination + search
  - Used by AskQuestionSheet/AddReviewSheet when trim is not preselected

---

## 7) UI/UX conventions (Flutter)
### Design tokens
- Card radius ~ 16 (`rounded-2xl` equivalent)
- Thumb radius ~ 12
- Pills/chips: full radius
- Prefer “vehicle-first” in global review cards; “user-first” in trim-scoped review cards.

### Specs display
Trim specs are a `Map<String, String>`. UI groups specs into categories using token-based classification:
- battery/range
- charging
- performance/drive
- dimensions/practicality
- engine/fuel (if non-EV specs exist)
- chassis/transmission
- other

Classification avoids substring bugs (e.g., “acceleration” should not match “ac”).

---

## 8) Localization (Flutter)
Arabic-first + English support via `arb` + generated `l10n`.
Hardcoded strings should be migrated to ARB keys gradually.

Important shared helper:
- `DateTimeText.relativeOrShort(context, dt)` returns localized relative time.

---

## 9) Key flows (how components connect)
### Posting a review/question from TrimCommunityScreen
1) User taps speed dial action
2) Sheet opens with `preselectedTrimId` + `lockTrim=true` (no fetching/picker)
3) Sheet uses `CommunityActionsCubit` to POST
4) Sheet returns `true`
5) Parent calls `TrimCommunityCubit.refreshAll()`

### Posting from Global CommunityScreen
1) Sheet opens without preselected trim
2) Trim selection opens `TrimPickerSheet` (paginated)
3) Sheet uses `CommunityActionsCubit` to POST
4) Parent calls `CommunityCubit.load()` to refresh global feed

---

## 10) Known pitfalls / guardrails (for AI changes)
- Don’t fetch all trims globally just for forms—use TrimPicker on demand.
- Keep pagination state per list; don’t reset feed unnecessarily.
- Avoid loading more while `searchQuery` is non-empty (local search).
- When API date is not ISO8601, normalize before parsing.
- Ensure review navigation uses `review.trimId`, not `review.id`.
- Backend search via Ransack requires explicit allowlists.

---

## 11) Roadmap (next)
- Implement **real-world range reports** (80%→20%) on vehicle/trim pages:
  - Model: `usage_reports`
  - Aggregation: median range by city/season/mix
- Surface insights in UI:
  - Vehicle details: “Real-world range in Damascus (n=…)”
  - Home discover ranking becomes city-aware
- Improve moderation/spam control for community submissions.

---

## 12) What an AI should ask before big changes
When editing API/data flow:
1) Is this screen global or trim-scoped?
2) Should this data be paginated? (`take/skip`)
3) Should selection be on-demand (TrimPicker) or preselected/locked?
4) Which cubit owns this state (read vs write)?
5) Are strings localized? If not, add ARB keys and use `context.l10n`.

---

If you want, I can also generate:
- a **PlantUML** diagram of module dependencies (Flutter cubits/repos/screens)
- an **API JSON schema** file for each endpoint to keep client/server aligned.