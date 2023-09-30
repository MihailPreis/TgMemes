//
//  ContentView.swift
//  TgMemes
//
//  Created by Mike Price on 29.09.2023.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		VStack(spacing: 15) {
			Text("welcome")
				.multilineTextAlignment(.center)
			
			Image(systemName: "flag.checkered.2.crossed")
				.font(.largeTitle)
				.foregroundStyle(.tint)
		}
		.padding()
	}
}

#Preview {
	ContentView()
}
