//
//  PlayerDetailView.swift
//  myHockey
//
//  Created by Brett Moxey on 23/4/2024.
//

import SwiftUI

struct PlayerDetailView: View {
    @EnvironmentObject private var teamsManager: TeamsManager
    var player: Player
    @State var games: [Player] = []
    @State var totalGoals: Int = 0
    @State var totalCards: Int = 0
    var body: some View {
        ForEach(games, id:\.id) {playerStat in
            HStack {
                Text("\(playerStat.name)")
                    .font(.subheadline)
                    .foregroundStyle(Color("DarkColor"))
                if playerStat.fillin {
                    Image(systemName: "person.fill.badge.plus")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color("DarkColor"), Color.orange)
                } else {
                    Image(systemName: "person.fill")
                        .foregroundColor(Color("AccentColor"))
                }
                Text("\(playerStat.date)")
                    .font(.subheadline)
                    .foregroundStyle(Color("DarkColor"))
                if playerStat.goalie == 1 {
                    Text(" (GK)")
                        .font(.subheadline)
                        .foregroundStyle(Color("DarkColor"))
                }
                if playerStat.greenCards > 0 {
                    Text(String(repeating: "▲", count: playerStat.greenCards))
                        .font(.system(size:24))
                        .foregroundStyle(Color.green)
                        .padding(.vertical, 0)
                        .padding(.horizontal, 0)
                }
                if playerStat.yellowCards > 0 {
                    Text(String(repeating: "■", count: playerStat.yellowCards))
                        .font(.system(size:24))
                        .foregroundStyle(Color.yellow)
                        .padding(.vertical, 0)
                        .padding(.horizontal, 0)
                }
                if playerStat.redCards > 0 {
                    Text(String(repeating: "●", count: playerStat.redCards))
                        .font(.system(size:24))
                        .foregroundStyle(Color.red)
                        .padding(.vertical, 0)
                        .padding(.horizontal, 0)
                }
                Spacer()
                if playerStat.goals > 0 {
                    Text(String(repeating: "●", count: playerStat.goals))
                        .font(.system(size:20))
                        .foregroundStyle(Color.green)
                        .padding(.vertical, 0)
                        .padding(.horizontal, 0)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(nil)
                }
            }
            .listRowBackground(Color("DarkColor").brightness(0.75))
        }
        .frame(height: 12)
        HStack {
            HStack {
                Text("Games:")
                    .foregroundStyle(Color.white)
                    .font(.subheadline)
                Text("\(player.numberGames)")
                    .foregroundStyle(Color.orange)
                    .font(.subheadline)
                Spacer()
            }
            HStack {
                Spacer()
                if totalCards > 0 {
                    Text("Cards:")
                        .foregroundStyle(Color.white)
                        .font(.subheadline)
                    Text("\(totalCards)")
                        .foregroundStyle(Color.orange)
                        .font(.subheadline)
                }
                Spacer()
            }
            HStack {
                Spacer()
                if totalGoals > 0 {
                    Text("Goals:")
                        .foregroundStyle(Color.white)
                        .font(.subheadline)
                    Text("\(totalGoals)")
                        .foregroundStyle(Color.orange)
                        .font(.subheadline)
                }
            }
        }
        .frame(height: 12)
        .listRowBackground(Color("DarkColor").brightness(0.1))
        .onAppear {
            Task {
                teamsManager.loadTeams()
                games = await getPlayer(player: player, teamsManager: teamsManager)
                totalGoals = games.reduce(0) { result, player in result + player.goals }
                totalCards = games.reduce(0) { result, player in result + player.greenCards + player.yellowCards + player.redCards }
            }
        }
    }
}

#Preview {
    PlayerDetailView(player: Player())
}
