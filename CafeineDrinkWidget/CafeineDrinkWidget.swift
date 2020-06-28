//
//  CafeineDrinkWidget.swift
//  CafeineDrinkWidget
//
//  Created by Edmond on 2020/6/27.
//

import WidgetKit
import SwiftUI
import Intents
import WebKit

struct Provider: IntentTimelineProvider {
    public func snapshot(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (SimpleTimeEntry) -> ()) {
        let entry = SimpleTimeEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    public func timeline(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleTimeEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleTimeEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct SimpleTimeEntry: TimelineEntry {
    public let date: Date
    public let configuration: ConfigurationIntent
}

extension SimpleTimeEntry {
    static let preivewEntry = SimpleTimeEntry(
        date: Date(),
        configuration: ConfigurationIntent()
    )
}

struct CaffeineWidgetData {

    public let drinkName: String
    public let drinkDate: Date
    public let caffeineAmount: Measurement<UnitMass>
    public let phoneName: String?
}

extension CaffeineWidgetData {
    public static let previewData = CaffeineWidgetData(
        drinkName: "Cappuccino",
        drinkDate: Date().advanced(by: -60 * 29 + 5),
        caffeineAmount: Measurement<UnitMass>(value: 56.23, unit: .milligrams),
        phoneName: "coffie"

    )
}

struct CafeineDrinkWidgetEntryView : View {

    var entry: Provider.Entry
    var data: CaffeineWidgetData
    let url: String = "https://www.baidu.com"

    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        ZStack {
            Color("cappuccino")

            LazyHStack {
                LazyVStack(alignment: .leading) {
                    CaffineAmountView(data: data)
                    Spacer()
                    DrinkView(data: data)
                }
                .padding(.all, 10)

                if widgetFamily == .systemMedium, let phoneName = data.phoneName {
                    Image(phoneName).resizable()
                }
                WKWebView(frame: .zero)
            }
        }
    }
}

struct CafeineDrinkWidget_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            CafeineDrinkWidgetEntryView(entry: .preivewEntry, data: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            CafeineDrinkWidgetEntryView(entry: .preivewEntry, data: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.colorScheme, .dark)

            CafeineDrinkWidgetEntryView(entry: .preivewEntry, data: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.sizeCategory, .extraExtraLarge)

            CafeineDrinkWidgetEntryView(entry: .preivewEntry, data: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
//                .isPlaceholder(true)

            CafeineDrinkWidgetEntryView(entry: .preivewEntry, data: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}






@main
struct CafeineDrinkWidget: Widget {
    private let kind: String = "CafeineDrinkWidget"

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(), placeholder: PlaceholderView()) { entry in
            CafeineDrinkWidgetEntryView(entry: entry, data: .previewData)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct CaffineAmountView: View {

    let data: CaffeineWidgetData

    var body: some View {
        LazyHStack {
            VStack(alignment: .leading) {
                Text("Caffeine")
                    .font(.body)
                    .foregroundColor(Color("espresso"))
                    .bold()

                Text(Formatter.measurement.string(from: data.caffeineAmount))
                    .font(.title)
                    .bold()
                    .foregroundColor(Color("espresso"))
                    .minimumScaleFactor(0.8)
            }

            Spacer(minLength: 0)
        }
        .padding(.all, 8.0)
        .background(ContainerRelativeShape().fill(Color("latte")))
    }
}

struct DrinkView: View {

    let data: CaffeineWidgetData

    var body: some View {

        LazyVStack(alignment: .leading) {
            Text("\(data.drinkName) ☕️")
                .font(.body)
                .bold()
                .foregroundColor(Color("milk"))

            /// NOTE: *New * Date provider API
            Text("\(data.drinkDate, style: .relative) ago")
                .font(.caption)
                .foregroundColor(Color("milk"))
        }
    }
}

extension Formatter {
    public static let measurement: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 2
        formatter.unitOptions = .providedUnit
        return formatter
    }()
}
