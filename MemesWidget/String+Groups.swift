//
//  String+Groups.swift
//  TgMemes
//
//  Created by Mike Price on 29.09.2023.
//

import Foundation

extension String {
	/// Get matched groups by regex pattern
	/// - Parameter regexPattern: Regex pattern
	/// - Returns: List of list of matched group
	func groups(for regexPattern: String) -> [[String]] {
		do {
			return try NSRegularExpression(pattern: regexPattern)
				.matches(in: self, range: NSRange(self.startIndex..., in: self))
				.map { match in
					(0..<match.numberOfRanges).map { index in
						Range(match.range(at: index), in: self).flatMap { String(self[$0]) } ?? ""
					}
				}
		} catch let error {
			NSLog("Invalid /\(regexPattern)/ regex: \(error.localizedDescription)")
			return []
		}
	}
}
