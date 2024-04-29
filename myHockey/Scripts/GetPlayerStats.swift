//
//  GetPlayerStats.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import Foundation
@MainActor
func getPlayerStats(teamsManager: TeamsManager) async -> [Player] {
    teamsManager.loadTeams()
    var myPlayer = Player()
    var players = [Player]()
    var lines: [String] = []
    var fillins: Bool = false
    var games: [Player] = []
    lines = GetUrl(url: "\(url)games/team-stats/" + teamsManager.currentTeam.compID + "?team_id=" + teamsManager.currentTeam.teamID)
    for i in 0 ..< lines.count {
        if lines[i].contains("Fill ins") { fillins = true }
        if lines[i].contains("\(url)games/statistics/") {
            if lines[i+1].contains(" (fill-in)") {
                fillins = true
                lines[i+1] = lines[i+1].replacingOccurrences(of: " (fill-in)", with: "")
            }
            myPlayer.id = UUID()
            myPlayer.statsLink = String(lines[i].split(separator: "\"")[1])
            myPlayer.fillin = fillins
            myPlayer.name = ""
            myPlayer.surname = ""
            myPlayer.captain = false
            (myPlayer.name, myPlayer.surname, myPlayer.captain) = FixName(fullname: lines[i+1].capitalized.trimmingCharacters(in: CharacterSet.letters.inverted))
            myPlayer.numberGames = Int(lines[i+7].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
//            myPlayer.goals = Int(lines[i+11].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
//            myPlayer.greenCards = Int(lines[i+15].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
//            myPlayer.yellowCards = Int(lines[i+19].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
//            myPlayer.redCards = Int(lines[i+23].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
//            myPlayer.goalie = Int(lines[i+27].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            
            games = await getPlayer(player: myPlayer, teamsManager: teamsManager)
            myPlayer.goals = games.reduce(0) { result, myPlayer in result + myPlayer.goals }
            myPlayer.greenCards = games.reduce(0) { result, myPlayer in result + myPlayer.greenCards }
            myPlayer.yellowCards = games.reduce(0) { result, myPlayer in result + myPlayer.yellowCards }
            myPlayer.redCards = games.reduce(0) { result, myPlayer in result + myPlayer.redCards }
            myPlayer.goalie = games.reduce(0) { result, myPlayer in result + myPlayer.goalie }
            print(myPlayer.name)
            players.append(myPlayer)
            fillins = false
        }
    }
    

    return players
}
