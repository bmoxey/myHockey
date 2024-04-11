//
//  GetTeams.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import Foundation
func getTeams(myComp: Teams) async -> [Teams] {
    var teams: [Teams] = []
    var lines: [String] = []
    lines = GetUrl(url: "\(url)pointscore/\(myComp.compID)/\(myComp.divID)")
    for i in 0 ..< lines.count {
        if lines[i].contains("\(url)games/team/") {
            let teamID = lines[i].split(separator: "/")[5].trimmingCharacters(in: .punctuationCharacters)
            let teamName = ShortTeamName(fullName: lines[i+1])
            let image = GetImage(teamName: teamName)
            teams.append(Teams(compName: myComp.compName, compID: myComp.compID, divName: myComp.divName, divID: myComp.divID, type: myComp.type, teamName: teamName, teamID: teamID, image: image))
        }
    }
    return teams
}
