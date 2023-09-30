//
//  MemeImage.swift
//  MemesWidgetExtension
//
//  Created by Mike Price on 29.09.2023.
//

import SwiftUI

enum MemeImage {
	case success(NSImage)
	case invalidTgChannel
	case invalidResponse(Error)
	case invalidParsing(Error)
	case unknown
	
	var asView: Image {
		switch self {
		case .success(let image):
			return Image(nsImage: image)
		default:
			return Image("MemePlaceholder")
		}
	}
}
