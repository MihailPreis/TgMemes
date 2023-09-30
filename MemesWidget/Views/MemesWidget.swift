//
//  MemesWidget.swift
//  MemesWidget
//
//  Created by Mike Price on 29.09.2023.
//

import WidgetKit
import SwiftUI

struct MemesWidget: Widget {
	let kind: String = "MemesWidget"

	var body: some WidgetConfiguration {
		AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: MemesWidgetProvider()) { entry in
			MemesWidgetEntryView(entry: entry)
				.containerBackground(.fill.tertiary, for: .widget)
				.widgetURL(makeWidgetURL(entry.info.postURL))
		}
		.contentMarginsDisabled()
		.configurationDisplayName("MemesWidget")
		.description("See last meme from telegram public channel.")
		.supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
	}
	
	private func makeWidgetURL(_ postURL: URL?) -> URL? {
		guard
			let encoded = postURL?.absoluteString
				.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		else { return nil }
		
		return URL(string: "tgmemes://\(encoded)")
	}
}
