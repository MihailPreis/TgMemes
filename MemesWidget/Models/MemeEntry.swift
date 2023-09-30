//
//  MemeEntry.swift
//  MemesWidgetExtension
//
//  Created by Mike Price on 29.09.2023.
//

import WidgetKit

struct MemeEntry: TimelineEntry {
	let info: MemeInfo
	let date: Date
	let configuration: ConfigurationAppIntent
}
