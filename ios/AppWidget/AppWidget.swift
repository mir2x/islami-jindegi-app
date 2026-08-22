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
  let countdownTarget: Date
  let prayerSchedule: [PrayerScheduleItem]
  let theme: String
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
    guard let rawValue = defaults?.string(forKey: "prayerSchedule"),
          let data = rawValue.data(using: .utf8),
          let schedule = try? JSONDecoder().decode([PrayerScheduleItem].self, from: data) else {
      return []
    }
    return schedule
  }

  private func savedDate(_ defaults: UserDefaults?, key: String) -> Date {
    let milliseconds = (defaults?.object(forKey: key) as? NSNumber)?.doubleValue ??
      Double(defaults?.string(forKey: key) ?? "")
    guard let milliseconds else {
      return Date()
    }
    return Date(timeIntervalSince1970: milliseconds / 1000)
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
      countdownTarget: savedDate(defaults, key: "countdownTarget"),
      prayerSchedule: savedPrayerSchedule(defaults),
      theme: savedText(defaults, key: "theme", fallback: "classic")
    )
  }

  func placeholder(in context: Context) -> IslamiJindegiWidgetEntry { entry() }
  func getSnapshot(in context: Context, completion: @escaping (IslamiJindegiWidgetEntry) -> Void) { completion(entry()) }
  func getTimeline(in context: Context, completion: @escaping (Timeline<IslamiJindegiWidgetEntry>) -> Void) {
    completion(Timeline(entries: [entry()], policy: .never))
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
    HStack(alignment: .top, spacing: 8 * scale) {
      VStack(alignment: .leading, spacing: 3) {
        Text(entry.hijriDate)
          .font(font(18 * scale, weight: .semibold))
          .layoutPriority(1)
        Text(entry.bangaliDate).font(font(15 * scale))
        if !entry.gregorianDate.isEmpty { Text(entry.gregorianDate).font(font(13 * scale)) }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      VStack(alignment: .leading, spacing: 3) {
        Text(entry.sunrise)
        Text(entry.sunset)
        Text(entry.location)
          .font(font(12 * scale, weight: .medium))
          .foregroundStyle(palette.accent)
          .lineLimit(1)
      }
      .font(font(12 * scale))
      .frame(width: min(118 * scale, availableWidth * 0.4), alignment: .leading)
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
  private var currentPrayerName: String {
    entry.currentPrayer.split(separator: " ").first.map(String.init) ?? "নামাজ"
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(alignment: .top, spacing: 10) {
        islamiJindegiAppIcon()
          .frame(width: 52, height: 52)
        VStack(alignment: .leading, spacing: 0) {
          Text(hijriDay)
            .font(.custom("SolaimanLipi", size: 34).weight(.bold))
          Text(hijriMonthAndYear)
            .font(.custom("SolaimanLipi", size: 16))
            .lineLimit(1)
            .minimumScaleFactor(0.65)
        }
      }
      .foregroundStyle(palette.text)

      Spacer(minLength: 0)
      VStack(spacing: 2) {
        Text("\(currentPrayerName) শেষ হতে")
          .font(.custom("SolaimanLipi", size: 19))
        Text(entry.countdownTarget, style: .timer)
          .font(.system(size: 28, weight: .bold, design: .rounded))
        HStack(spacing: 12) {
          Text(entry.nextPrayerName)
          Divider().frame(height: 22)
          Text(entry.nextPrayerTime)
        }
        .font(.custom("SolaimanLipi", size: 16))
        .foregroundStyle(palette.text)
      }
      .frame(maxWidth: .infinity)
      .foregroundStyle(palette.text)
      Spacer(minLength: 0)
    }
    .padding(14)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .containerWidgetBackground(palette.background)
    .widgetURL(widgetDestination(for: "/qurans"))
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
  private let shortPrayerTitles = ["ফজর", "যোহর", "আসর", "মাগরিব", "ইশা"]

  private var schedule: [(title: String, sourceTitle: String, time: String)] {
    shortPrayerTitles.enumerated().map { index, shortTitle in
      let item = entry.prayerSchedule.indices.contains(index)
        ? entry.prayerSchedule[index]
        : nil
      return (
        title: shortTitle,
        sourceTitle: item?.title ?? shortTitle,
        time: item?.time ?? "--:--"
      )
    }
  }

  private var currentPrayerName: String {
    entry.currentPrayer.split(separator: " ").first.map(String.init) ?? "নামাজ"
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      HStack(spacing: 8) {
        islamiJindegiAppIcon()
          .frame(width: 34, height: 34)
        VStack(alignment: .leading, spacing: 1) {
          Text(entry.hijriDate)
            .font(.custom("SolaimanLipi", size: 15).weight(.semibold))
            .lineLimit(1)
            .minimumScaleFactor(0.65)
          Text(entry.bangaliDate)
            .font(.custom("SolaimanLipi", size: 11))
            .lineLimit(1)
        }
        Spacer(minLength: 0)
        Text(entry.sunrise)
        .font(.custom("SolaimanLipi", size: 11))
        .foregroundStyle(palette.accent)
        .lineLimit(1)
      }
      .foregroundStyle(palette.text)

      Divider().overlay(palette.divider)

      HStack(spacing: 0) {
        ForEach(Array(schedule.enumerated()), id: \.offset) { _, prayer in
          let isCurrent = !entry.currentPrayer.isEmpty && entry.currentPrayer.contains(prayer.sourceTitle)
          VStack(spacing: 3) {
            Text(prayer.title)
              .font(.custom("SolaimanLipi", size: 13).weight(.semibold))
              .lineLimit(1)
              .minimumScaleFactor(0.65)
            Text(prayer.time)
              .font(.custom("SolaimanLipi", size: 16).weight(.bold))
              .lineLimit(1)
              .minimumScaleFactor(0.65)
          }
          .foregroundStyle(isCurrent ? palette.accent : palette.text)
          .padding(.vertical, 4)
          .background(isCurrent ? palette.accent.opacity(0.12) : .clear)
          .overlay(
            RoundedRectangle(cornerRadius: 5)
              .stroke(isCurrent ? palette.accent : .clear, lineWidth: 1)
          )
          .frame(maxWidth: .infinity)
        }
      }

      Text("\(currentPrayerName) শেষ হতে বাকি: \(entry.countdownTarget, style: .timer)")
        .font(.custom("SolaimanLipi", size: 13))
        .frame(maxWidth: .infinity, alignment: .center)
      .foregroundStyle(palette.accent)
    }
    .padding(.horizontal, 14)
    .padding(.vertical, 10)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
