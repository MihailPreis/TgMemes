//
//  MemeInfo.swift
//  MemesWidgetExtension
//
//  Created by Mike Price on 29.09.2023.
//

import Foundation

struct MemeInfo {
	let image: MemeImage
	let author: String?
	let views: String?
	let postURL: URL?
	
	static var zero: MemeInfo {
		MemeInfo(image: .unknown, author: nil, views: nil, postURL: nil)
	}
}
