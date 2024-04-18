//
//  GetComps.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import Foundation
func getComps() async -> [Teams] {
//    try? await Task.sleep(nanoseconds: 200_000_000)
    var myCompName = ""
    var myCompID = ""
    var comps: [Teams] = []
    var lines: [String] = []
    lines = GetUrl(url: "\(url)games/")
    for i in 0 ..< lines.count {
        if lines[i].contains("/reports/games/") {
            myCompName = lines[i-5]
            myCompID = String(lines[i].split(separator: "/")[4]).trimmingCharacters(in: .punctuationCharacters)
        }
        if lines[i].contains("/games/\(myCompID)/") {
            let myDivName = ShortDivName(fullName: String(lines[i+1]))
            let myDivID = String(lines[i].split(separator: "/")[4]).trimmingCharacters(in: .punctuationCharacters)
            var type = "👫"
            if myDivName.contains("Boy") { type =  "👦🏻" }
            if myDivName.contains("Girl") { type = "👧🏻" }
            if myDivName.contains("Men") {
                type = "👨🏻"
                if myDivName.contains("+") || myDivName.contains("Over") || myDivName.contains("Master") { type = "👴🏻" }
            }
            if myDivName.contains("Women") {
                type = "👩🏻"
                if myDivName.contains("+") || myDivName.contains("Over") || myDivName.contains("Master") { type = "👵🏻" }
            }
            comps.append(Teams(compName: myCompName, compID: myCompID, divName: myDivName, divID: myDivID, type: type))
        }
    }
    return comps
}
