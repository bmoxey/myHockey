//
//  GetGround.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import Foundation
func getGround(fixture: Fixture) async -> String {
    var address: String = ""
    var lines: [String] = []
    lines = GetUrl(url: "\(url)game/\(fixture.gameID)")
    for i in 0 ..< lines.count {
        if lines[i] == "Venue" { address = lines[i+4].trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    if address.contains(fixture.venue) {
        address = address.replacingOccurrences(of: fixture.venue, with: "").trimmingCharacters(in: .punctuationCharacters).trimmingCharacters(in: .whitespaces)
    }
    return address
}
