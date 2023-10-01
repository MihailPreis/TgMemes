//
//  MemesWidgetProvider.swift
//  MemesWidgetExtension
//
//  Created by Mike Price on 29.09.2023.
//

import WidgetKit
import SwiftSoup
import SwiftUI

struct MemesWidgetProvider: AppIntentTimelineProvider {
	func placeholder(in context: Context) -> MemeEntry {
		MemeEntry(info: .zero, date: Date(), configuration: ConfigurationAppIntent())
	}
	
	func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> MemeEntry {
		guard !context.isPreview else {
			return MemeEntry(info: .zero, date: Date(), configuration: configuration)
		}
		
		let info = await loadLastMeme(for: configuration)
		return MemeEntry(info: info, date: Date(), configuration: configuration)
	}
	
	func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<MemeEntry> {
		guard !context.isPreview else {
			return Timeline(
				entries: [
					MemeEntry(info: .zero, date: Date(), configuration: configuration)
				],
				policy: .never
			)
		}
		
		let date = Date()
		
		let info = await loadLastMeme(for: configuration)
		let entry = MemeEntry(info: info, date: date, configuration: configuration)
		
		return Timeline(entries: [entry], policy: .after(date.addingTimeInterval(configuration.interval.inSeconds)))
	}
	
	private func loadLastMeme(for configuration: ConfigurationAppIntent) async -> MemeInfo {
		let tgChannel = getTgChannel(configuration.tgChannel)
		
		guard
			let previewURL = URL(string: "https://t.me/s/\(tgChannel)"),
			let rootURL = URL(string: "https://t.me/\(tgChannel)")
		else {
			NSLog("Invalid TG channel: \(configuration.tgChannel)")
			return MemeInfo(image: .invalidTgChannel, author: nil, views: nil, postURL: nil)
		}
		
		let data: Data
		do {
			let (_data, _) = try await URLSession.shared.data(from: previewURL)
			data = _data
		} catch {
			NSLog("Invalid meta request: \(error)")
			return MemeInfo(image: .invalidResponse(error), author: nil, views: nil, postURL: rootURL)
		}
		
		guard let html = String(data: data, encoding: .utf8) else {
			NSLog("Invalid data to string convertation")
			return MemeInfo(image: .invalidResponse(NSError(domain: "Data convert", code: 3)), author: nil, views: nil, postURL: rootURL)
		}
		
		let doc: Document
		do {
			doc = try SwiftSoup.parse(html, previewURL.absoluteString)
		} catch {
			NSLog("Invalid parsing: \(error)")
			return MemeInfo(image: .invalidParsing(error), author: nil, views: nil, postURL: rootURL)
		}
		
		guard
			let lastItem = try? doc.getElementsByClass("tgme_widget_message_photo_wrap").last(),
			let attributes = lastItem.getAttributes(),
			let imageRawURL = attributes.get(key: "style")
				.groups(for: #"background-image:url\(\'(.+)\'\)"#)
				.last?
				.last,
			let imageURL = URL(string: imageRawURL)
		else {
			NSLog("Something went wrong in content. Skip image load.")
			return MemeInfo(image: .invalidTgChannel, author: nil, views: nil, postURL: rootURL)
		}
		
		let imageData: Data
		do {
			let (_imageData, _) = try await URLSession.shared.data(from: imageURL)
			imageData = _imageData
		} catch {
			NSLog("Invalid image request: \(error)")
			return MemeInfo(image: .invalidResponse(error), author: nil, views: nil, postURL: rootURL)
		}
		
		#if os(macOS)
		guard let image = NSImage(data: imageData) else {
			NSLog("Invalid create image from data.")
			return MemeInfo(image: .invalidResponse(NSError(domain: "Data convert", code: 3)), author: nil, views: nil, postURL: rootURL)
		}
		#elseif os(iOS)
		guard let image = UIImage(data: imageData) else {
			NSLog("Invalid create image from data.")
			return MemeInfo(image: .invalidResponse(NSError(domain: "Data convert", code: 3)), author: nil, views: nil, postURL: rootURL)
		}
		#endif
		
		let postURL: URL? = URL(string: attributes.get(key: "href"))
		let author: String? = try? lastItem.parent()?.getElementsByClass("tgme_widget_message_from_author").first()?.text()
		let views: String? = try? lastItem.parent()?.getElementsByClass("tgme_widget_message_views").first()?.text()
		
		NSLog("Success load")
		return MemeInfo(image: .success(image), author: author, views: views, postURL: postURL ?? rootURL)
	}
	
	private func getTgChannel(_ input: String) -> String {
		if let url = URL(string: input), url.host() == "t.me" {
			return url.lastPathComponent
		}
		if input.hasSuffix("@") {
			return input.replacingOccurrences(of: "@", with: "")
		}
		return input
	}
}
