//
//  MemeImage.swift
//  MemesWidgetExtension
//
//  Created by Mike Price on 29.09.2023.
//

import SwiftUI

enum MemeImage {
	#if os(macOS)
	case success(NSImage)
	#elseif os(iOS)
	case success(UIImage)
	#endif
	case invalidTgChannel
	case invalidResponse(Error)
	case invalidParsing(Error)
	case unknown
	
	var asView: Image {
		switch self {
		case .success(let image):
			#if os(macOS)
			return Image(nsImage: image)
			#elseif os(iOS)
			return Image(uiImage: image)
			#endif
		default:
			return Image("MemePlaceholder")
		}
	}
}
