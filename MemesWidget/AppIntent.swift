//
//  AppIntent.swift
//  MemesWidget
//
//  Created by Mike Price on 29.09.2023.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
	static var title: LocalizedStringResource = "Configuration"
	static var description = IntentDescription("Select favourite telegram public channel and refresh rate.")
	
	@Parameter(
		title: "Telegram channel",
		description: "Public channel tag",
		default: "fucking_memes",
		inputOptions: String.IntentInputOptions(
			keyboardType: .URL,
			capitalizationType: .none,
			multiline: false,
			autocorrect: false,
			smartQuotes: false,
			smartDashes: false
		)
	)
	var tgChannel: String
	
	@Parameter(title: "Refresh rate", default: .superFast)
	var interval: RefreshInterval
	
	@Parameter(title: "Show view count", default: true)
	var isShowViewCount: Bool
	
	@Parameter(title: "Show author", default: true)
	var isShowAuthor: Bool
}

enum RefreshInterval: String, AppEnum {
	case superFast, fastes, fast, hour, halfDay, day
	
	static var typeDisplayRepresentation: TypeDisplayRepresentation = "Refresh Interval"
	static var caseDisplayRepresentations: [RefreshInterval : DisplayRepresentation] = [
		.superFast: "Every 5 minutes",
		.fastes: "Every 15 minutes",
		.fast: "Every 30 minutes",
		.hour: "Every 1 hour",
		.halfDay: "Every 12 hours",
		.day: "Every day"
	]
	
	var inSeconds: TimeInterval {
		switch self {
		case .superFast: return 300
		case .fastes: return 900
		case .fast: return 1800
		case .hour: return 3600
		case .halfDay: return 43200
		case .day: return 86400
		}
	}
}
