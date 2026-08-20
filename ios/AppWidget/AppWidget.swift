import SwiftUI
import WidgetKit

private let appGroupId = "group.islami_jindegi"
private let widgetActions = [
  ("কুরআন", "book.closed", "/qurans"),
  ("বই", "books.vertical", "/books"),
  ("বয়ান", "speaker.wave.2", "/bayans"),
  ("মালফুযাত", "quote.bubble", "/malfuzat"),
  ("মাসায়েল", "questionmark.circle", "/masails"),
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
  private func entry() -> IslamiJindegiWidgetEntry {
    let defaults = UserDefaults(suiteName: appGroupId)
    return IslamiJindegiWidgetEntry(
      date: Date(),
      hijriDate: defaults?.string(forKey: "hijriDate") ?? "হিজরি তারিখ",
      bangaliDate: defaults?.string(forKey: "bangaliDate") ?? "বাংলা তারিখ",
      gregorianDate: defaults?.string(forKey: "gregorianDate") ?? "Gregorian date",
      location: defaults?.string(forKey: "location") ?? "লোকেশন নির্ধারণ করুন",
      currentPrayer: defaults?.string(forKey: "currentPrayer") ?? "",
      nextPrayer: defaults?.string(forKey: "nextPrayer") ?? "নামাজের সময়",
      sunrise: defaults?.string(forKey: "sunrise") ?? "",
      sunset: defaults?.string(forKey: "sunset") ?? "",
      theme: defaults?.string(forKey: "theme") ?? "classic"
    )
  }

  func placeholder(in context: Context) -> IslamiJindegiWidgetEntry { entry() }
  func getSnapshot(in context: Context, completion: @escaping (IslamiJindegiWidgetEntry) -> Void) {
    completion(entry())
  }
  func getTimeline(in context: Context, completion: @escaping (Timeline<IslamiJindegiWidgetEntry>) -> Void) {
    // The Flutter app explicitly reloads this timeline after saving fresh data.
    completion(Timeline(entries: [entry()], policy: .never))
  }
}

struct IslamiJindegiWidgetView: View {
  @Environment(\.widgetFamily) private var family
  let entry: IslamiJindegiWidgetEntry

  private var isDark: Bool { entry.theme == "dark" }
  private var background: Color {
    isDark ? Color(red: 0.07, green: 0.13, blue: 0.13) : Color(red: 0.02, green: 0.29, blue: 0.28)
  }
  private var primaryText: Color { isDark ? .white : Color(red: 0.96, green: 0.94, blue: 0.84) }
  private var accent: Color { Color(red: 0.96, green: 0.77, blue: 0.30) }

  private func destination(for route: String) -> URL {
    URL(string: "appWidget://message?route=\(route)")!
  }

  private var shortcuts: some View {
    LazyVGrid(
      columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 3),
      spacing: 4,
    ) {
      ForEach(widgetActions, id: \.2) { action in
        Link(destination: destination(for: action.2)) {
          Label(action.0, systemImage: action.1)
            .font(.caption2)
            .lineLimit(1)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .foregroundStyle(primaryText)
            .background(primaryText.opacity(0.12), in: RoundedRectangle(cornerRadius: 5))
        }
      }
    }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 7) {
      Text(entry.hijriDate).font(.headline).foregroundStyle(primaryText).lineLimit(1)
      Text(entry.bangaliDate).font(.subheadline).foregroundStyle(primaryText).lineLimit(1)
      Text(entry.gregorianDate).font(.caption).foregroundStyle(primaryText.opacity(0.82)).lineLimit(1)
      Divider().overlay(primaryText.opacity(0.28))
      Text(entry.location).font(.caption).foregroundStyle(accent).lineLimit(1)
      if !entry.currentPrayer.isEmpty {
        Text(entry.currentPrayer).font(.subheadline.weight(.semibold)).foregroundStyle(accent).lineLimit(1)
      }
      Text(entry.nextPrayer).font(.caption).foregroundStyle(primaryText).lineLimit(1)
      if family == .systemMedium {
        shortcuts
      } else if !entry.sunrise.isEmpty || !entry.sunset.isEmpty {
        Text("\(entry.sunrise)   \(entry.sunset)").font(.caption2).foregroundStyle(primaryText.opacity(0.78)).lineLimit(1)
      }
    }
    .padding()
    .background(background)
    .widgetURL(URL(string: "appWidget://message?route=/"))
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
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}
