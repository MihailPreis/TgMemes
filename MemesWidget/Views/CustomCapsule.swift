//
//  CustomCapsule.swift
//  MemesWidgetExtension
//
//  Created by Mike Price on 29.09.2023.
//

import SwiftUI

struct CustomCapsule: ViewModifier {
	enum Mode {
		case `default`
		case error
		
		var background: Material {
			switch self {
			case .default: return .regularMaterial
			case .error: return .thickMaterial
			}
		}
		
		var cornerRadius: CGFloat {
			switch self {
			case .default: return 16
			case .error: return 8
			}
		}
	}
	
	var mode: Mode = .default
	
	func body(content: Content) -> some View {
		content
			.padding(.vertical, 2)
			.padding(.horizontal, 5)
			.background(mode.background, in: RoundedRectangle(cornerRadius: mode.cornerRadius, style: .continuous))
	}
}
