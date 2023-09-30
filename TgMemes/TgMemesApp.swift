//
//  TgMemesApp.swift
//  TgMemes
//
//  Created by Mike Price on 29.09.2023.
//

import SwiftUI

@main
struct TgMemesApp: App {
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@Environment(\.openURL) var openURL
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.onOpenURL { url in
					guard
						url.scheme == "tgmemes",
						let host = url.host(),
						let raw = host.removingPercentEncoding,
						let postURL = URL(string: raw)
					else { return }
					NSLog("Open '\(postURL)'")
					openURL(postURL)
				}
		}
	}
}

final class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationDidFinishLaunching(_ notification: Notification) {
		guard
			let userInfo = notification.userInfo,
			let launchKey = userInfo["NSApplicationLaunchIsDefaultLaunchKey"] as? Int,
			launchKey == 0
		else {
			NSLog("Launch first time")
			return
		}
		
		NSLog("Launch from cache")
		
		if let window = NSApplication.shared.windows.first {
			window.close()
		}
	}
	
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		true
	}
}
