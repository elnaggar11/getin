# Project guidance for AI agents

## Scope and reference

This is a Flutter/Dart coffee ordering app. Follow the existing feature and shared infrastructure before introducing a new architecture or dependency. The cart is a useful end-to-end reference: `lib/features/cart/` covers API calls, request and response models, Cubit states, screens, pagination, checkout and shared cart state. Cross-check the closest feature when its conventions differ; not every feature has the same structure. Existing code is evidence of current behavior, not proof that every implementation is correct.

## Feature structure and state

- Place feature-specific code under `lib/features/<feature>/`, generally in `cubit/`, `domain/model/`, `domain/request/`, `domain/repository/`, and `presentation/screens/` or `presentation/widgets/`. Follow the target feature's existing layout rather than moving unrelated files.
- Use the existing `flutter_bloc` Cubit pattern: expose operations through the feature Cubit, emit loading, success and failure states as appropriate, and render or react through `BlocBuilder`, `BlocListener`, or `BlocConsumer`. Provide feature-scoped Cubits with `BlocProvider`; dispose controllers and subscriptions owned by them or widgets.
- Put API operations in a repository using the shared `DioService` from `lib/core/data_source/dio_helper.dart`; inspect `ApiResponse.isError` and the actual response shape. Models parse API data (`fromMap` or `fromJson` according to the feature); request objects serialize payloads. Prefer explicit types and handle malformed or missing data and failures.
- Register new shared services or repositories in `setupLocator()` in `lib/core/utils/Locator.dart`, following existing GetIt registrations. Resolve shared state such as `GeneralCubit` through the existing provider/locator conventions. Keep cart count and other shared state synchronized when relevant.
- Use the existing pagination package and controller where the feature needs pagination; handle last page and errors and dispose the controller.

## UI, navigation and localization

- Reuse `lib/shared/widgets/`, `lib/core/theme/`, `lib/core/resources/`, existing extensions and `Alerts` where they fit. Extract feature-specific reusable widgets into the feature's presentation directory. Support loading, empty, error and retry states as applicable.
- Add named routes to `lib/core/Router/Router.dart` and use the existing navigation helpers where appropriate. Preserve expected route arguments and return values.
- Localize new user-visible text through `LocalizationHelper.tr` and the ARB files in `lib/core/localization/l10n/` (English, Arabic and Turkish). Keep keys consistent across locales and regenerate localizations with `flutter gen-l10n`; do not manually edit generated localization files.
- Use existing generated asset references and project asset conventions; don't hand-edit generated files when their source or generator should be updated instead.

## API and behavior safeguards

- `DioService` centralizes base URL, authorization, language headers, loading and error handling. Do not create a parallel HTTP client for ordinary feature calls or duplicate its global behavior. Match the endpoint's expected body, query and form encoding; do not assume every response has the same `data` shape.
- Preserve existing API field names and behavioral contracts unless a requested change requires otherwise. In cart/checkout, verify pickup versus delivery, address, coupon, payment method, points, totals and success/failure behavior against the relevant screens, requests and repository before changing them. Avoid inferring backend rules solely from UI labels.
- Do not copy apparent defects as conventions: cart currently includes inconsistent naming and nullable/dynamic results, and its points-payment flow should be checked against the `Either` result rather than assuming a non-null result means success. Avoid unrelated fixes, but do not reproduce these patterns in new code.
- Never add credentials, tokens, payment data or sensitive response bodies to source code or logs. Avoid adding debug prints; preserve privacy when diagnosing failures.

## Validation

- Keep changes focused and format changed Dart files with `dart format`. Run `flutter analyze` and relevant `flutter test` tests when applicable; add focused tests for changed behavior, especially serialization, error paths and checkout logic. Report pre-existing failures or unavailable tooling honestly.
- For UI changes, check relevant loading, error and empty states and Arabic/RTL as well as the affected flow when practical. For localization or asset changes, regenerate the corresponding outputs and verify them.
