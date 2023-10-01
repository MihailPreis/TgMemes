//
//  MemesWidgetEntryView.swift
//  MemesWidgetExtension
//
//  Created by Mike Price on 29.09.2023.
//

import SwiftUI

struct MemesWidgetEntryView: View {
	@Environment(\.widgetFamily) var widgetFamily
	
	let entry: MemesWidgetProvider.Entry
	
	var body: some View {
		ImageView(image: entry.info.image.asView)
			.overlay(alignment: .bottomLeading) {
				if
					let views = entry.info.views,
					entry.configuration.isShowViewCount
				{
					HStack(spacing: 0) {
						Text(views)
							#if os(macOS)
							.font(.callout)
							#elseif os(iOS)
							.font(.caption)
							#endif
						Image(systemName: "eye")
							#if os(macOS)
							.font(.caption)
							#elseif os(iOS)
							.font(.caption2)
							#endif
							.bold()
					}
					.modifier(CustomCapsule())
					.padding(8)
				}
			}
			.overlay(alignment: .bottomTrailing) {
				if
					let author = entry.info.author,
					entry.configuration.isShowAuthor,
					widgetFamily != .systemSmall
				{
					Text(author)
						#if os(macOS)
						.font(.callout)
						#elseif os(iOS)
						.font(.caption)
						#endif
						.modifier(CustomCapsule())
						.padding(8)
				}
			}
			.overlay {
				switch entry.info.image {
				case .invalidTgChannel:
					Text("Invalid Telegram channel tag or channel not public!")
						.multilineTextAlignment(.center)
						.foregroundStyle(.red)
						#if os(iOS)
						.font(.callout)
						#endif
						.modifier(CustomCapsule(mode: .error))
						.padding()
					
				case .invalidResponse,
						.invalidParsing:
					Text("Something went wrong. We'll try again soon.")
						.multilineTextAlignment(.center)
						.foregroundStyle(.red)
						#if os(iOS)
						.font(.callout)
						#endif
						.modifier(CustomCapsule(mode: .error))
						.padding()
					
				case .unknown,
						.success:
					EmptyView()
				}
			}
	}
}
