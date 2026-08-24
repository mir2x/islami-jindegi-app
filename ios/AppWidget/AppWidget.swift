import SwiftUI
import UIKit
import WidgetKit

private let appGroupId = "group.islami_jindegi"
private let widgetActions = [
  ("কুরআন", "quran", "/qurans"),
  ("বই", "book", "/books"),
  ("বয়ান", "bayan", "/bayans"),
  ("মালফুযাত", "malfuzat", "/malfuzat"),
  ("মাসায়েল", "masail", "/masail"),
  ("দোয়া", "dua", "/duas"),
]

private func widgetDestination(for route: String) -> URL {
  var components = URLComponents()
  components.scheme = "appWidget"
  components.host = "message"
  components.queryItems = [
    URLQueryItem(name: "homeWidget", value: "1"),
    URLQueryItem(name: "route", value: route),
  ]
  return components.url!
}

@ViewBuilder
private func widgetIcon(named name: String) -> some View {
  if let path = Bundle.main.path(forResource: name, ofType: "png", inDirectory: "WidgetIcons"),
     let image = UIImage(contentsOfFile: path) {
    Image(uiImage: image)
      .resizable()
      .scaledToFit()
  } else {
    Image(systemName: "square.dashed")
      .resizable()
      .scaledToFit()
  }
}

@ViewBuilder
private func islamiJindegiAppIcon() -> some View {
  if let path = Bundle.main.path(forResource: "Icon-App-1024x1024@1x", ofType: "png"),
     let image = UIImage(contentsOfFile: path) {
    Image(uiImage: image)
      .resizable()
      .scaledToFit()
  } else {
    Image(systemName: "app.fill")
      .resizable()
      .scaledToFit()
  }
}

struct IslamiJindegiWidgetEntry: TimelineEntry {
  let date: Date
  let hijriDate: String
  let bangaliDate: String
  let gregorianDate: String
  let location: String
  let currentPrayer: String
  let nextPrayer: String
  let nextPrayerName: String
  let nextPrayerTime: String
  let sunrise: String
  let sunset: String
  // Absent until the app has written a full refresh, and cleared once it has
  // elapsed. `Text(date, style: .timer)` counts *upwards* past a date in the
  // past, so a missing target must never be substituted with `Date()`.
  let countdownTarget: Date?
  let countdownName: String
  let countdownEnding: Bool
  let prayerSchedule: [PrayerScheduleItem]
  let theme: String
  let locale: String

  // For example "ইশা শেষ হতে" while Isha is running, or "ফজর শুরু হতে" between prayers.
  var countdownHeadline: String {
    "\(countdownName) \(countdownEnding ? "শেষ" : "শুরু") হতে"
  }
}

struct PrayerScheduleItem: Codable, Identifiable {
  let title: String
  let time: String

  var id: String { title }
}

struct IslamiJindegiWidgetProvider: TimelineProvider {
  private func savedText(_ defaults: UserDefaults?, key: String, fallback: String) -> String {
    guard let value = defaults?.string(forKey: key), !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      return fallback
    }
    return value
  }

  private func savedPrayerSchedule(_ defaults: UserDefaults?) -> [PrayerScheduleItem] {
    if let rawValue = defaults?.string(forKey: "prayerSchedule"),
       let data = rawValue.data(using: .utf8),
       let schedule = try? JSONDecoder().decode([PrayerScheduleItem].self, from: data),
       !schedule.isEmpty {
      return schedule
    }

    // The app also stores every prayer under its own key. A snapshot written
    // before the JSON list landed still has those, so the schedule stays
    // readable instead of falling back to five "--:--" columns.
    let perPrayer = (0..<5).compactMap { index -> PrayerScheduleItem? in
      guard let time = defaults?.string(forKey: "schedule\(index)Time"), !time.isEmpty else {
        return nil
      }
      return PrayerScheduleItem(
        title: defaults?.string(forKey: "schedule\(index)Title") ?? "",
        time: time
      )
    }
    return perPrayer.count == 5 ? perPrayer : []
  }

  private func savedCountdownTarget(_ defaults: UserDefaults?) -> Date? {
    let milliseconds = (defaults?.object(forKey: "countdownTarget") as? NSNumber)?.doubleValue ??
      Double(defaults?.string(forKey: "countdownTarget") ?? "")
    guard let milliseconds, milliseconds > 0 else { return nil }
    let target = Date(timeIntervalSince1970: milliseconds / 1000)
    return target > Date() ? target : nil
  }

  private func savedCountdownName(_ defaults: UserDefaults?) -> String {
    let stored = defaults?.string(forKey: "countdownName")?
      .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    if !stored.isEmpty { return stored }

    // Data written before the app stored the countdown's prayer separately.
    let current = defaults?.string(forKey: "currentPrayer") ?? ""
    let name = current.split(separator: " ").first.map(String.init) ?? ""
    return name.isEmpty ? "নামাজ" : name
  }

  private func entry() -> IslamiJindegiWidgetEntry {
    let defaults = UserDefaults(suiteName: appGroupId)
    return IslamiJindegiWidgetEntry(
      date: Date(),
      hijriDate: savedText(defaults, key: "hijriDate", fallback: "হিজরি তারিখ"),
      bangaliDate: savedText(defaults, key: "bangaliDate", fallback: "বাংলা তারিখ"),
      gregorianDate: savedText(defaults, key: "gregorianDate", fallback: ""),
      location: savedText(defaults, key: "location", fallback: "ঢাকা, বাংলাদেশ"),
      currentPrayer: savedText(defaults, key: "currentPrayer", fallback: ""),
      nextPrayer: savedText(defaults, key: "nextPrayer", fallback: "নামাজের সময়"),
      nextPrayerName: savedText(defaults, key: "nextPrayerName", fallback: "ফজর"),
      nextPrayerTime: savedText(defaults, key: "nextPrayerTime", fallback: "--:--"),
      sunrise: savedText(defaults, key: "sunrise", fallback: "সূর্যোদয় --:--"),
      sunset: savedText(defaults, key: "sunset", fallback: "সূর্যাস্ত --:--"),
      countdownTarget: savedCountdownTarget(defaults),
      countdownName: savedCountdownName(defaults),
      countdownEnding: (defaults?.string(forKey: "countdownEnding") ?? "1") != "0",
      prayerSchedule: savedPrayerSchedule(defaults),
      theme: savedText(defaults, key: "theme", fallback: "classic"),
      locale: savedText(defaults, key: "locale", fallback: "bn")
    )
  }

  func placeholder(in context: Context) -> IslamiJindegiWidgetEntry { entry() }
  func getSnapshot(in context: Context, completion: @escaping (IslamiJindegiWidgetEntry) -> Void) { completion(entry()) }

  func getTimeline(in context: Context, completion: @escaping (Timeline<IslamiJindegiWidgetEntry>) -> Void) {
    let current = entry()

    // A `.never` policy leaves the widget frozen on whatever it last drew: an
    // expired countdown, or yesterday's times if the app is never reopened.
    // Ask WidgetKit to come back when the countdown runs out, bounded so a
    // widget with no data yet still retries and a nearby prayer boundary does
    // not burn the refresh budget.
    let now = Date()
    let wanted = current.countdownTarget?.addingTimeInterval(1)
      ?? now.addingTimeInterval(15 * 60)
    let refreshAt = min(
      max(wanted, now.addingTimeInterval(2 * 60)),
      now.addingTimeInterval(60 * 60)
    )

    completion(Timeline(entries: [current], policy: .after(refreshAt)))
  }
}

private struct WidgetPalette {
  let background: Color
  let text: Color
  let accent: Color
  let divider: Color

  static func forTheme(_ theme: String) -> WidgetPalette {
    switch theme {
    case "light":
      return WidgetPalette(
        background: Color(red: 0.969, green: 0.949, blue: 0.910),
        text: Color(red: 0.122, green: 0.141, blue: 0.122),
        accent: Color(red: 0.106, green: 0.420, blue: 0.290),
        divider: Color(red: 0.106, green: 0.420, blue: 0.290).opacity(0.24)
      )
    case "dark":
      return WidgetPalette(
        background: Color(red: 0.090, green: 0.098, blue: 0.114),
        text: Color(red: 0.949, green: 0.941, blue: 0.918),
        accent: Color(red: 0.498, green: 0.784, blue: 0.663),
        divider: Color.white.opacity(0.16)
      )
    default:
      return WidgetPalette(
        background: Color(red: 0.745, green: 0.859, blue: 0.843),
        text: Color(red: 0.129, green: 0.145, blue: 0.161),
        accent: Color(red: 0.098, green: 0.329, blue: 0.424),
        divider: Color(red: 0.098, green: 0.329, blue: 0.424).opacity(0.22)
      )
    }
  }
}

struct IslamiJindegiWidgetView: View {
  let entry: IslamiJindegiWidgetEntry

  private var palette: WidgetPalette { .forTheme(entry.theme) }

  private func font(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
    .custom("SolaimanLipi", size: size).weight(weight)
  }

  private func datesAndSun(scale: CGFloat, availableWidth: CGFloat) -> some View {
    // Sizes below are larger than the rest of the widget on purpose — every
    // one of them is still `base * scale`, and `scale` already floors at 0.72
    // for the smallest supported widget frame (see `content`), so a small
    // screen shrinks these exactly as before; only the full-size ceiling on a
    // normal or large widget moved up.
    HStack(alignment: .top, spacing: 8 * scale) {
      VStack(alignment: .leading, spacing: 3) {
        Text(entry.hijriDate)
          .font(font(21 * scale, weight: .semibold))
          .layoutPriority(1)
        Text(entry.bangaliDate).font(font(17 * scale))
        if !entry.gregorianDate.isEmpty { Text(entry.gregorianDate).font(font(15 * scale)) }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      VStack(alignment: .leading, spacing: 3) {
        Text(entry.sunrise)
        Text(entry.sunset)
        Text(entry.location)
          .font(font(14 * scale, weight: .medium))
          .foregroundStyle(palette.accent)
          .lineLimit(1)
      }
      .font(font(14 * scale))
      .frame(width: min(130 * scale, availableWidth * 0.4), alignment: .leading)
    }
    .foregroundStyle(palette.text)
    .lineLimit(1)
    .minimumScaleFactor(0.65)
  }

  private func prayer(scale: CGFloat) -> some View {
    VStack(alignment: .leading, spacing: 3) {
      if !entry.currentPrayer.isEmpty {
        Text(entry.currentPrayer)
          .font(font(19 * scale, weight: .bold))
          .foregroundStyle(palette.accent)
      }
      Text(nextPrayerText)
        .font(font(15 * scale, weight: .medium))
        .foregroundStyle(palette.text)
    }
    .lineLimit(1)
    .minimumScaleFactor(0.65)
  }

  private func shortcuts(scale: CGFloat) -> some View {
    HStack(spacing: 7 * scale) {
      ForEach(widgetActions, id: \.2) { action in
        Link(destination: widgetDestination(for: action.2)) {
          widgetIcon(named: action.1)
            .frame(maxWidth: .infinity, maxHeight: 29 * scale)
            .frame(maxWidth: .infinity, minHeight: 29 * scale)
        }
      }
    }
  }

  private var nextPrayerText: String {
    let text = entry.nextPrayer.trimmingCharacters(in: .whitespacesAndNewlines)
    if text.hasPrefix("পরবর্তী") || text.hasPrefix("Next") { return text }
    return "পরবর্তীতে \(text)"
  }

  private var content: some View {
    GeometryReader { geometry in
      // iPhone widget dimensions vary by model. Scale down before the layout
      // runs so all three information rows and the shortcut row remain visible.
      let scale = max(
        0.72,
        min(1, min(geometry.size.width / 329, geometry.size.height / 155))
      )

      VStack(alignment: .leading, spacing: max(2, 4 * scale)) {
        datesAndSun(scale: scale, availableWidth: geometry.size.width)
        Divider().overlay(palette.divider)
        prayer(scale: scale)
        Spacer(minLength: 0)
        shortcuts(scale: scale)
      }
      .padding(max(9, 10 * scale))
      .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
    }
  }

  @ViewBuilder
  private var backgroundedContent: some View {
    if #available(iOSApplicationExtension 17.0, *) {
      content.containerBackground(for: .widget) { palette.background }
    } else {
      content.background(palette.background)
    }
  }

  var body: some View {
    backgroundedContent
  }
}

struct AppWidget: Widget {
  let kind = "AppWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: IslamiJindegiWidgetProvider()) { entry in
      IslamiJindegiWidgetView(entry: entry)
    }
    .configurationDisplayName("ইসলামী যিন্দেগী")
    .description("আজকের তারিখ ও নামাজের সময় দেখুন।")
    .supportedFamilies([.systemMedium])
  }
}

private struct HijriPrayerWidgetView: View {
  let entry: IslamiJindegiWidgetEntry

  private var palette: WidgetPalette { .forTheme(entry.theme) }
  private var hijriDay: String { entry.hijriDate.split(separator: " ").first.map(String.init) ?? "" }
  private var hijriMonthAndYear: String {
    entry.hijriDate.split(separator: " ").dropFirst().joined(separator: " ")
  }

  private func font(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
    .custom("SolaimanLipi", size: size).weight(weight)
  }

  var body: some View {
    // A systemSmall widget is 141pt wide on an iPhone SE and 170pt on a Pro
    // Max. The Bangla strings here ("রবিউল আউয়াল, ১৪৪৮", "মাগরিব, ইফতার শুরু হতে")
    // are far wider than their English equivalents, so every size is derived
    // from the real width instead of being hard-coded for one device.
    GeometryReader { geometry in
      let scale = min(1.15, max(0.85, geometry.size.width / 155))

      VStack(alignment: .leading, spacing: 0) {
        HStack(alignment: .center, spacing: 6 * scale) {
          islamiJindegiAppIcon()
            .frame(width: 32 * scale, height: 32 * scale)
          VStack(alignment: .leading, spacing: 0) {
            Text(hijriDay)
              .font(font(23 * scale, weight: .bold))
            Text(hijriMonthAndYear)
              .font(font(10 * scale))
          }
          .lineLimit(1)
          .minimumScaleFactor(0.5)
        }
        .foregroundStyle(palette.text)

        Spacer(minLength: 2)

        VStack(spacing: 1) {
          Text(entry.countdownHeadline)
            .font(font(15 * scale))
          countdownTimer(entry.countdownTarget, locale: entry.locale)
            .font(.system(size: 24 * scale, weight: .bold, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(palette.accent)
          HStack(spacing: 7 * scale) {
            Text(entry.nextPrayerName)
            Divider().frame(height: 15 * scale)
            Text(entry.nextPrayerTime)
          }
          .font(font(13 * scale))
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .foregroundStyle(palette.text)

        Spacer(minLength: 2)
      }
      .padding(11 * scale)
      .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
    }
    .containerWidgetBackground(palette.background)
    .widgetURL(widgetDestination(for: "/qurans"))
  }
}

// A live countdown, or a static zero when there is nothing to count down to.
// `Text(date, style: .timer)` has no "stopped" state, so the absent case has to
// be a separate view rather than a target in the past.
//
// Every other number on the widget is formatted by the app in the user's
// language; `.timer` follows the *device* locale, so it is pinned here to keep
// Bangla and Western digits from appearing side by side.
@ViewBuilder
private func countdownTimer(_ target: Date?, locale: String) -> some View {
  if let target {
    Text(target, style: .timer)
      .environment(\.locale, Locale(identifier: locale))
  } else {
    Text(verbatim: locale.hasPrefix("bn") ? "০০:০০" : "00:00")
  }
}

private extension View {
  @ViewBuilder
  func containerWidgetBackground(_ color: Color) -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      self.containerBackground(for: .widget) { color }
    } else {
      self.background(color)
    }
  }
}

struct HijriPrayerWidget: Widget {
  let kind = "HijriPrayerWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: IslamiJindegiWidgetProvider()) { entry in
      HijriPrayerWidgetView(entry: entry)
    }
    .configurationDisplayName("হিজরি তারিখ ও নামাজ")
    .description("আজকের হিজরি তারিখ ও নামাজের সময় দেখুন।")
    .supportedFamilies([.systemSmall])
  }
}

private struct PrayerScheduleWidgetView: View {
  let entry: IslamiJindegiWidgetEntry

  private var palette: WidgetPalette { .forTheme(entry.theme) }
  // Keep the five columns visually consistent. Full names such as
  // "যুহর, যাওয়াল" and "মাগরিব, ইফতার" are intentionally not used here.
  private let shortPrayerTitles = ["ফজর", "যুহর", "আসর", "মাগরিব", "ইশা"]

  private var schedule: [(title: String, time: String)] {
    shortPrayerTitles.enumerated().map { index, shortTitle in
      let item = entry.prayerSchedule.indices.contains(index)
        ? entry.prayerSchedule[index]
        : nil
      let time = item?.time.isEmpty == false ? item!.time : "--:--"
      return (title: shortTitle, time: time)
    }
  }

  private func font(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
    .custom("SolaimanLipi", size: size).weight(weight)
  }

  var body: some View {
    // systemMedium runs from 292pt wide (iPhone SE) to 364pt (Pro Max), and
    // five prayer columns plus a countdown row have to fit in every one of them.
    GeometryReader { geometry in
      let scale = min(1.1, max(0.85, geometry.size.width / 329))

      VStack(alignment: .leading, spacing: 4 * scale) {
        HStack(spacing: 8 * scale) {
          islamiJindegiAppIcon()
            .frame(width: 32 * scale, height: 32 * scale)
          VStack(alignment: .leading, spacing: 1) {
            Text(entry.hijriDate)
              .font(font(15 * scale, weight: .semibold))
            Text(entry.bangaliDate)
              .font(font(11 * scale))
          }
          .lineLimit(1)
          .minimumScaleFactor(0.6)

          Spacer(minLength: 4 * scale)

          Text(entry.sunrise)
            .font(font(11 * scale))
            .foregroundStyle(palette.accent)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .layoutPriority(-1)
        }
        .foregroundStyle(palette.text)

        Divider().overlay(palette.divider)

        HStack(spacing: 2 * scale) {
          ForEach(Array(schedule.enumerated()), id: \.offset) { _, prayer in
            VStack(spacing: 2) {
              Text(prayer.title)
                .font(font(13 * scale, weight: .semibold))
              Text(prayer.time)
                .font(font(16 * scale, weight: .bold))
            }
            .lineLimit(1)
            .minimumScaleFactor(0.55)
            .foregroundStyle(palette.text)
            .padding(.vertical, 4 * scale)
            .padding(.horizontal, 2 * scale)
            .frame(maxWidth: .infinity)
          }
        }

        Spacer(minLength: 0)

        // Mirrors the systemSmall widget's countdown, which is the one known to
        // render correctly. Two details there are load-bearing and were missing
        // here:
        //
        // 1. The timer gets an explicit `.system` font. Inheriting the custom
        //    "SolaimanLipi" face from the enclosing `.font(_:)` puts a
        //    self-updating `Text(_, style: .timer)` — whose width the system
        //    reserves ahead of time — on a Bangla font with no monospaced-digit
        //    support, so `.monospacedDigit()` cannot stabilise its width.
        // 2. The timer must win the width contest against the label. Here it
        //    shares one line with a long Bangla headline under `lineLimit(1)`,
        //    unlike the small widget where it owns a full-width line of its own.
        //    `layoutPriority` gives the timer its space first and lets
        //    `minimumScaleFactor` shrink the *label* instead — which is what
        //    `.fixedSize()` was previously (and unreliably) approximating.
        HStack(spacing: 4 * scale) {
          Text("\(entry.countdownHeadline) বাকি:")
            .font(font(13 * scale))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
          countdownTimer(entry.countdownTarget, locale: entry.locale)
            .font(.system(size: 14 * scale, weight: .semibold, design: .rounded))
            .monospacedDigit()
            .lineLimit(1)
            .layoutPriority(1)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .foregroundStyle(palette.accent)
      }
      .padding(.horizontal, 13 * scale)
      .padding(.vertical, 9 * scale)
      .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
    }
    .containerWidgetBackground(palette.background)
    .widgetURL(widgetDestination(for: "/namaz-times"))
  }
}

struct PrayerScheduleWidget: Widget {
  let kind = "PrayerScheduleWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: IslamiJindegiWidgetProvider()) { entry in
      PrayerScheduleWidgetView(entry: entry)
    }
    .configurationDisplayName("আজকের নামাজের সময়")
    .description("আজকের পাঁচ ওয়াক্ত নামাজের সময় দেখুন।")
    .supportedFamilies([.systemMedium])
  }
}

@main
struct IslamiJindegiWidgetBundle: WidgetBundle {
  var body: some Widget {
    AppWidget()
    HijriPrayerWidget()
    PrayerScheduleWidget()
  }
}
