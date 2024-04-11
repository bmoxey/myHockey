//
//  GetGame.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import Foundation
func getGame(fixture: Fixture) async ->  (Round, [Player]) {
    try? await Task.sleep(nanoseconds: 200_000_000)
    var myRound: Round = Round()
    var players: [Player] = []
    var myPlayer: Player = Player()
    var lines: [String] = []
    var attended: Bool = false
    var scores: String = ""
    var homePlayer: Bool = false
    var played: Bool = true
    lines = GetUrl(url: "\(url)game/\(fixture.gameID)")
    for i in 0 ..< lines.count {
        if lines[i].contains("\(url)games/team/") {
            if myRound.homeTeam == "" {
                myRound.homeTeam = lines[i+1].trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                if myRound.awayTeam == "" {
                    myRound.awayTeam = lines[i+1].trimmingCharacters(in: .whitespacesAndNewlines)
                } else {
                    if scores == "" && played {
                        scores = lines[i+7]
                        if lines[i+9] == "FF" {
                            scores = scores + lines[i+11]
                        }
                        (myRound.homeGoals, myRound.awayGoals) = GetScores(scores: scores, seperator: "-")
                    }
                }
            }
        }
        if lines[i].contains("Results for this match are not currently available.") {played = false}
        if lines[i].contains(" drew!") {
            scores = lines[i+4]
            (myRound.homeGoals, myRound.awayGoals) = GetScores(scores: scores, seperator: "-")
        }
        if String(lines[i]).trimmingCharacters(in: .whitespacesAndNewlines) == myRound.homeTeam { homePlayer = true }
        if String(lines[i]).trimmingCharacters(in: .whitespacesAndNewlines) == myRound.awayTeam { homePlayer = false }
        if lines[i].contains("Attended") {attended = true}
        if lines[i].contains("Did not attend") {attended = false}
        if lines[i].contains("\(url)games/statistics/") && attended {
            myPlayer.name = lines[i+1].trimmingCharacters(in: .whitespacesAndNewlines)
            (myPlayer.name, myPlayer.surname, myPlayer.captain) = FixName(fullname: myPlayer.name)
            myPlayer.goals = Int(lines[i+7].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            myPlayer.greenCards = Int(lines[i+11].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            myPlayer.yellowCards = Int(lines[i+15].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            myPlayer.redCards = Int(lines[i+19].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            myPlayer.goalie = Int(lines[i+23].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            if homePlayer {myPlayer.team = ShortTeamName(fullName: myRound.homeTeam)}
            else {myPlayer.team = ShortTeamName(fullName: myRound.awayTeam)}
            players.append(myPlayer)
            myPlayer = Player()
            played = true
        }
    }
    myRound.homeTeam = ShortTeamName(fullName: myRound.homeTeam).trimmingCharacters(in: .whitespacesAndNewlines)
    myRound.awayTeam = ShortTeamName(fullName: myRound.awayTeam).trimmingCharacters(in: .whitespacesAndNewlines)
    myRound.myTeam = fixture.myTeam.trimmingCharacters(in: .whitespacesAndNewlines)
    myRound.venue = fixture.venue
    myRound.field = fixture.field
    myRound.result = fixture.result
    myRound.date = fixture.date
    myRound.roundNo = fixture.roundNo
    myRound.homeGoals = myRound.homeGoals.trimmingCharacters(in: .whitespacesAndNewlines)
    myRound.awayGoals = myRound.awayGoals.trimmingCharacters(in: .whitespacesAndNewlines)
    return (myRound, players)
}
