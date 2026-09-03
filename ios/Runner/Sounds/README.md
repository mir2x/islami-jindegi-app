# iOS notification sound — one manual Xcode step

`azan_short.caf` is the sound the prayer-alarm **backstop** notification plays
(`PrayerAlarmBackstop` in `lib/core/services/prayer_alarm_backstop.dart`).

## Why it lives here and not in `assets/`

`UNNotificationSound(named:)` resolves names against the app bundle's root or
`Library/Sounds` — it cannot see Flutter assets, which are packaged inside
`Frameworks/App.framework/flutter_assets/`. A sound referenced by name that iOS
cannot resolve does not error; it silently falls back to the default alert tone.

## Why this file and not one of the full azans

iOS truncates a notification sound at **30 seconds** and accepts only
uncompressed/lightly-compressed formats (Linear PCM, IMA4, µ-law, a-law in
`aiff`/`wav`/`caf`) — an mp3 does not play. `azan_short.mp3` is 13.4 s, the only
azan in the app under the cap, so it is converted to Linear PCM CAF:

```
ffmpeg -i assets/sounds/azan_short.mp3 -c:a pcm_s16le -ar 44100 -ac 1 \
  ios/Runner/Sounds/azan_short.caf
```

## The step that needs Xcode

Add this file to the **Runner** target so it ships in the bundle root:

1. Open `ios/Runner.xcworkspace`.
2. Drag `azan_short.caf` into the Runner group.
3. Tick **Copy items if needed** and the **Runner** target.
4. Confirm it appears under *Build Phases → Copy Bundle Resources*.

Until that is done the backstop still fires on time — it just plays the default
iOS alert tone instead of the azan. Nothing breaks, so this is safe to land
before the Xcode change.

## What the backstop is for

On iOS the `alarm` package rings from an in-process `Timer` held up by a silent
background audio session. If iOS terminates the app, every pending timer dies
and no azan plays at all. A scheduled `UNNotificationRequest` is owned by the
system and fires regardless, so one is registered 15 s behind every planned
alarm and cancelled the moment the real alarm rings. See the class docs for the
full reasoning.
