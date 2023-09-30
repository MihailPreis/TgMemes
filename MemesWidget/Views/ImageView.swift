//
//  ImageView.swift
//  MemesWidgetExtension
//
//  Created by Mike Price on 29.09.2023.
//

import SwiftUI

struct ImageView: View {
	let bgSaturationRate: CGFloat = 0.25
	
	let image: Image
	
	var body: some View {
		ZStack {
			image
				.resizable()
				.saturation(bgSaturationRate)
				.blur(radius: (1 - bgSaturationRate) * 20)
			
			image
				.resizable()
				.aspectRatio(contentMode: .fit)
		}
	}
}
