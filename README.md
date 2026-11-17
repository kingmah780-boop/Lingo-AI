# Lingo AI – The King Studio (v0.3)

Flutter language-learning app with a working local study-reminder notification implementation.

## Alarm / study reminder
- Choose a reminder time.
- Turn the reminder on or off.
- Choose one-time (next occurrence) or daily repeat.
- Android notification permission is requested when enabling the reminder.
- The reminder is scheduled locally on the device and does not require an internet connection.
- Uses an inexact Android schedule so Android battery/doze policies may delay delivery slightly.

## Important: Android project setup
This source archive currently contains `lib/`, `pubspec.yaml`, and this README. It does not contain generated Android/iOS platform folders yet.

On a computer with Flutter installed, open a terminal in this folder and run:

```bash
flutter create . --platforms=android
flutter pub get
```

Then open `android/app/src/main/AndroidManifest.xml` and add this permission directly under the `<manifest ...>` opening tag, before `<application>`:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

Build the APK with:

```bash
flutter build apk --release
```

The APK will be created at `build/app/outputs/flutter-apk/app-release.apk`.

## Notes
- The alarm code uses `flutter_local_notifications`, `flutter_timezone`, and `timezone`.
- First-time notification permission must be allowed on Android 13 and newer.
- The source has not been built or device-tested in this environment. Run `flutter pub get` and `flutter build apk` to validate it on your Flutter/Android SDK setup.
- AI tutoring and paid subscriptions remain mock/demo features; they are not real connected services.
