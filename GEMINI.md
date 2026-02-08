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
- **Hot Topic**: 
  - trending car model based on community Q&A volume
  - HotTopic.id = car_model_id (model-level, not trim-level)
---

## 2) System architecture overview

### Mobile (Flutter)
- Uses `go_router` typed routes with a bottom navigation shell.
- Uses **BLoC/Cubit** for state management.
- Uses `BaseFormHelper` for common form field management, and `IPasswordConfirmationFormHelper` for forms requiring password confirmation. Specific form helpers like `LoginFormHelper`, `SignupFormHelper`, `ForgotPasswordFormHelper`, `PasswordResetFormHelper` extend `BaseFormHelper`.
- Uses a `RestClient` + `ResponseCache` for HTTP caching.
- Uses token auth (stored in `ITokensRepository`) + `AuthNotifier` (login status).
- Manages user data and state through `ApiUserRepository` (remote) and `LocalUserRepository` (local cache).
---

## 3.5) Client-Side Data Models

This section describes key data models used within the Flutter application, primarily for representing API responses and internal state.

### HomeData
- **Purpose**: Aggregates various data points for the `HomeScreen` (trending cars, hot topics, latest questions, latest reviews).
- **Structure**: Contains `List<CarTrimSummary>`, `List<HotTopic>`, `List<Question>`, `List<Review>`.

### HotTopic
- **Purpose**: Represents a trending car model topic based on community engagement (questions/answers).
- ID meaning: id is car_model_id.
- **Structure**: `id`, `name`, `makeName`, `questionsCount`, `answersCount`, `isHot`.

### CarTrimSummary
- **Purpose**: A lightweight summary of a vehicle trim, used for lists and previews (e.g., trending cars, search results, similar cars).
- **Structure**: `id`, `name`, `modelName`, `makeName`, `bodyType`, `yearStart`, `yearEnd`, `priceMin`, `priceMax`, `currency`, `isFeatured`, `imageUrl`, `range`, `batteryCapacity`, `acceleration` (all `SpecValue`).

### Question
- **Purpose**: Represents a community question.
- **Structure**: `id`, `car_trim_id`, `trim_name`, `model_name`, `user_name`, `title`, `body`, `answers_count`, `created_at`.

### Review
- **Purpose**: Represents a community review for a car trim.
- **Structure**: `id`, `user_name`, `rating`, `comment`, `created_at`, `car_trim_id`, `car_trim_name`, `car_model_name`.

### User
- **Purpose**: Represents an authenticated user of the application.
- **Structure**: `id`, `fullName`, `email`, `phoneNumber`, `role`, `activated`, `emailVerifiedAt`, `phoneNumberVerifiedAt`, `createdAt`, `identityConfirmedAt`.

---

## 4) Mobile API contract (current)
Base: `/api/v1`

**Note on API Endpoint Definition:**
While `Auth` and `User` related endpoints are centralized in `lib/api/endpoints.dart`, `Car Data` and `Community` endpoints are currently hardcoded directly within their respective repository implementations (`lib/features/vehicle/repositories/car_data_repository.dart` and `lib/features/community/community_repository.dart`). This should be considered for future refactoring to centralize all API endpoint definitions for better maintainability.

### Reference data
- `GET /car-data/body-types`
- `GET /car-data/makes`
- `GET /car-data/models`
- `GET /car-data/trims` (supports `search`, `take`, `skip`, filters)
- `GET /car-data/trims/{id}` (trim detail + specs)

### Authentication
- `POST /register`
- `POST /login`
- `POST /logout`
- `POST /request_otp`
- `POST /verify_otp`
- `POST /forget-password` (Forgot Password - sends reset link)
- `POST /user/change_password` (Reset Password)

### Recommendations
- `GET /car-data/trending-cars` (Popularity) - Returns `List<CarTrimSummary>`
- `GET /car-data/hot-topics` (Most Asked About) - Returns `List<HotTopic>`
- `GET /car-data/trims/{id}/similar` (Recommendation) - Returns `List<CarTrimSummary>`
- `GET /car-data/trims/{id}/also-liked` (Collaborative) - Returns `List<CarTrimSummary>`

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
  - supports filtering through:
    car_model_id optional (model-scoped Q&A)
    car_trim_id optional (trim-scoped Q&A)
  - returns: `id, car_trim_id, trim_name, model_name, user_name, title, body, answers_count, created_at`
  - pagination: take, skip.
- `GET /community/questions/{id}` returns question with answers
- `POST /community/questions` (auth required)
  - backend supports either model/trim; current app uses trim-based posting
- `POST /community/questions/{id}/answers` (auth required)

**Date format note:** API may return `"YYYY-MM-DD HH:MM:SS"`. Flutter normalizes to ISO by replacing space with `T` before `DateTime.parse`.

---

## 5) Flutter app structure & routing
### Routing
[GoRouter] Full paths for routes:
           ├─ (ShellRoute)
           │ ├─/home (Widget)
           │ ├─/vehicles (Widget)
           │ └─/community (Widget)
           ├─/questions/:id (Widget)
           ├─/profile/login (Widget)
           ├─/profile/signup (Widget)
           ├─/forgot-password (Widget)
           ├─/reset-password (Widget)
           ├─/profile/emaill-verification (Widget)
           ├─/profile (Widget)
           ├─/vehicles/:id (Widget)
           │ ├─/vehicles/:id/community/reviews (Widget)
           │ └─/vehicles/:id/community/qa (Widget)
           └─/profile/activity (Widget)
            /hot-topics (Widget) — HotTopicsScreen
            /hot-topics/:id (Widget) — ModelQuestionsScreen (model-scoped Q&A list)
            :id = car_model_id
            optional query param: ?title=... (used for AppBar title; preferred over extra for deep links)


### Key screens
- **HomeScreen**: discover vehicles + latest community
- **VehiclesListScreen**: search/filter/pagination (future polish)
- **VehicleDetailsScreen**: sliver header (pinned title), grouped specs, previews for reviews/questions
- **TrimCommunityScreen**: Tabs (Reviews / Q&A), lazy loading, speed dial for posting
- **CommunityScreen**: Global feed of questions+reviews (filters + search + lazy loading)
- **QuestionDetailsScreen**: question + answers + link to related trim (vehicle details)
- **ForgotPasswordScreen**: Screen for users to request a password reset link.
- **ResetPasswordScreen**: Screen for users to set a new password using a reset token.
- HotTopicsScreen: View-all hot topics list with pagination + local search
- ModelQuestionsScreen: Questions list filtered by model (car_model_id)

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
- `ForgotPasswordCubit`: Handles password reset link requests.
- `ResetPasswordCubit`: Handles setting a new password using a reset token.
- `EmailVerificationCubit`: Manages email verification process.
- `LoginCubit`: Handles user login.
- `QuestionsCubit`: Manages listing and pagination of questions.
- `ReviewsCubit`: Manages listing and pagination of reviews.
- `SignupCubit`: Manages user registration.
- `UserCubit`: Manages user-specific state and actions.
- `MyAnsweredQuestionsCubit`: Manages listing of questions answered by the current user.
- `MyQuestionsCubit`: Manages listing of questions asked by the current user.
- `MyReviewsCubit`: Manages listing of reviews posted by the current user.
- `TrimCommunityCubit`: Manages community content (reviews/Q&A) for a specific vehicle trim.
- `TrimCommunityPreviewCubit`: Manages preview data for community content on vehicle detail pages.
- HotTopicsCubit: Loads /car-data/hot-topics with take/skip pagination. Local search filters loaded items. Guardrail: avoid loadMore() while searchQuery is non-empty (local search)
- ModelQuestionsCubit: Paginated questions list for a model using car_model_id.
  Reuses QuestionCard + same lazy loading pattern as trim-scoped lists.

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

### Hot Topics UI
- Home Hot Topics uses HotTopicFeaturedCard (more visual hierarchy; safe in horizontal list)
“View all” Hot Topics uses:
  - Top-ranked items can use HotTopicFeaturedCard
  - Remaining items use a compact list card (no Spacer() in unbounded vertical constraints)
- Skeletons:
  - HotTopicFeaturedCardSkeleton for featured cards
  - HotTopicCardSkeleton for compact list rows and load-more footer

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

### Forgot/Reset Password Flow
1) User navigates to `ForgotPasswordScreen` (usually from Login).
2) User enters email and submits.
3) `ForgotPasswordCubit` calls `IAuthRepository.forgotPassword` to request an OTP be sent to the email.
4) User is redirected to `OtpPasswordResetScreen`, passing the email.
5) User enters the OTP received in their email on the `OtpPasswordResetScreen`.
6) `OtpPasswordResetCubit` calls `IAuthRepository.verifyOtpForPasswordReset` to verify the OTP.
7) On successful OTP verification, a token is received and stored in an `IPasswordResetTokenRepository`, and the user is redirected to `ResetPasswordScreen`.
8) User enters new password and confirmation.
9) `ResetPasswordCubit` calls `IAuthRepository.resetPassword` to update the password (this call is authenticated using the token obtained in step 7).
10) On success, `AuthNotifier.endPasswordResetSession()` is called (and the reset token should be cleared) and user is redirected to Login.

---

## 10) Known pitfalls / guardrails (for AI changes)
- Don’t fetch all trims globally just for forms—use TrimPicker on demand.
- Keep pagination state per list; don’t reset feed unnecessarily.
- Avoid loading more while `searchQuery` is non-empty (local search).
- When API date is not ISO8601, normalize before parsing.
- Ensure review navigation uses `review.trimId`, not `review.id`.
- When creating new form helpers, always extend `BaseFormHelper` (or `IPasswordConfirmationFormHelper` when applicable) to ensure consistent form management and validation.
- Backend search via Ransack requires explicit allowlists.
- Avoid Spacer() / Expanded() inside Column when the widget can receive unbounded height  (common in slivers). This caused:
  RenderFlex children have non-zero flex but incoming height constraints are unbounded
- For featured cards in lists, either:
  wrap in a fixed-height SizedBox(height: ...), or
  use layouts that don’t require flexible height.
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
6) Update `GEMINI.md` if needed after completing a task.
