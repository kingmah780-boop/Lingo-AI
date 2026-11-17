# Lingo AI v0.2 — The King Studio

## Implemented in this starter
- Persian / English interface choice
- Selectable learning language (18 options)
- Home, Learn, Progress, Profile tabs
- Four sample lesson units with vocabulary, meanings, examples and next-step flow
- Lesson completion awards points and updates in-app progress
- Premium teaser area

## Run
1. Install Flutter SDK and Android Studio.
2. Extract this ZIP.
3. If Android/iOS platform folders are absent, run `flutter create .` from this folder.
4. Run `flutter pub get`.
5. Run `flutter run` with an emulator or Android device connected.

## Important limitations
This is a functional UI prototype, not a production release:
- The sample lesson content is currently English-focused, even if another target language is selected.
- Progress is in memory and resets when the app restarts.
- The sound icon is visual only; text-to-speech and speech recognition are not connected.
- There is no real AI tutor/backend, user account, cloud sync, offline download manager, or subscription purchase yet.
- Premium is a preview only; no payment is collected.
- Before publishing, implement persistent storage, full translations/RTL QA, secure backend, privacy policy, age-appropriate design, accessibility and store-specific billing.

## Recommended next engineering milestones
1. Persist progress and selected language locally.
2. Build lesson content packs for each supported language.
3. Add text-to-speech and speech practice.
4. Add AI conversation through a secure backend (never embed secret API keys in the app).
5. Add separate compliant billing flows for Google Play and Iranian app stores.
6. Test on real Android devices and prepare signed release builds.
