import SwiftUI
import WidgetKit

private let appGroupId = "group.islami_jindegi"
private let widgetActions = [
  ("কুরআন", "book.closed", "/qurans"),
  ("বই", "books.vertical", "/books"),
  ("বয়ান", "speaker.wave.2", "/bayans"),
  ("মালফুযাত", "quote.bubble", "/malfuzat"),
  ("মাসায়েল", "questionmark.circle", "/masail"),
  ("দোয়া", "hands.clap", "/duas"),
]

struct IslamiJindegiWidgetEntry: TimelineEntry {
  let date: Date
  let hijriDate: String
  let bangaliDate: String
  let gregorianDate: String
  let location: String
  let currentPrayer: String
  let nextPrayer: String
  let sunrise: String
  let sunset: String
  let theme: String
}

struct IslamiJindegiWidgetProvider: TimelineProvider {
  private func savedText(_ defaults: UserDefaults?, key: String, fallback: String) -> String {
    guard let value = defaults?.string(forKey: key), !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      return fallback
    }
    return value
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
      sunrise: savedText(defaults, key: "sunrise", fallback: ""),
      sunset: savedText(defaults, key: "sunset", fallback: ""),
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
  @Environment(\.widgetFamily) private var family
  let entry: IslamiJindegiWidgetEntry

  private var palette: WidgetPalette { .forTheme(entry.theme) }

  private func destination(for route: String) -> URL {
    var components = URLComponents()
    components.scheme = "appWidget"
    components.host = "message"
    components.queryItems = [URLQueryItem(name: "route", value: route)]
    return components.url!
  }

  private func font(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
    .custom("SolaimanLipi", size: size).weight(weight)
  }

  private var datesAndSun: some View {
    HStack(alignment: .top, spacing: 12) {
      VStack(alignment: .leading, spacing: 3) {
        Text(entry.hijriDate).font(font(family == .systemSmall ? 16 : 18, weight: .semibold))
        Text(entry.bangaliDate).font(font(14))
        if !entry.gregorianDate.isEmpty { Text(entry.gregorianDate).font(font(12)) }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      VStack(alignment: .leading, spacing: 4) {
        if !entry.sunrise.isEmpty { Text(entry.sunrise) }
        if !entry.sunset.isEmpty { Text(entry.sunset) }
        Text(entry.location).foregroundStyle(palette.accent).lineLimit(1)
      }
      .font(font(13))
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .foregroundStyle(palette.text)
    .lineLimit(1)
    .minimumScaleFactor(0.72)
  }

  private var prayer: some View {
    VStack(alignment: .leading, spacing: 3) {
      if !entry.currentPrayer.isEmpty {
        Text(entry.currentPrayer)
          .font(font(family == .systemSmall ? 16 : 18, weight: .bold))
          .foregroundStyle(palette.accent)
      }
      Text(entry.nextPrayer).font(font(14, weight: .medium)).foregroundStyle(palette.text)
    }
    .lineLimit(1)
    .minimumScaleFactor(0.72)
  }

  private var shortcuts: some View {
    HStack(spacing: 4) {
      ForEach(widgetActions, id: \.2) { action in
        Link(destination: destination(for: action.2)) {
          VStack(spacing: 2) {
            Image(systemName: action.1).font(.system(size: 18, weight: .medium))
            Text(action.0).font(font(10, weight: .medium))
          }
          .foregroundStyle(palette.accent)
          .frame(maxWidth: .infinity, minHeight: 39)
          .background(palette.text.opacity(0.08), in: RoundedRectangle(cornerRadius: 7))
        }
      }
    }
  }

  private var smallLayout: some View {
    VStack(alignment: .leading, spacing: 7) {
      Text(entry.hijriDate).font(font(16, weight: .semibold))
      Text(entry.bangaliDate).font(font(14))
      Divider().overlay(palette.divider)
      prayer
      Spacer(minLength: 0)
      Text(entry.location).font(font(12)).foregroundStyle(palette.accent).lineLimit(1)
    }
  }

  private var expandedLayout: some View {
    VStack(alignment: .leading, spacing: family == .systemLarge ? 11 : 7) {
      datesAndSun
      Divider().overlay(palette.divider)
      prayer
      Spacer(minLength: 0)
      shortcuts
    }
  }

  private var content: some View {
    Group {
      if family == .systemSmall { smallLayout } else { expandedLayout }
    }
    .padding(family == .systemSmall ? 13 : 15)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    if family == .systemSmall {
      backgroundedContent.widgetURL(destination(for: "/"))
    } else {
      backgroundedContent
    }
  }
}

@main
struct AppWidget: Widget {
  let kind = "AppWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: IslamiJindegiWidgetProvider()) { entry in
      IslamiJindegiWidgetView(entry: entry)
    }
    .configurationDisplayName("ইসলামী যিন্দেগী")
    .description("আজকের তারিখ ও নামাজের সময় দেখুন।")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}
