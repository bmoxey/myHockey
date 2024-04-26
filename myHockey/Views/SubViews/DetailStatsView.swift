//
//  DetailStatsView.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import SwiftUI

struct DetailStatsView: View {
    @State var player: Player
    @State var selectedPlayer: Player = Player()
    var body: some View {
        HStack {
            if player.fillin {
                Image(systemName: "person.fill.badge.plus")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("DarkColor"), Color.orange)
            } else {
                if player.numberGames == 0 {
                    Image(systemName: "person")
                        .foregroundStyle(Color.orange)
                } else {
                    Image(systemName: "person.fill")
                        .foregroundStyle(Color.orange)
                }
            }
            Text(player.name)
                .foregroundStyle(Color("DarkColor"))
            Spacer()
            Text("\(player.numberGames)")
                .frame(width: 30)
                .foregroundStyle(Color("DarkColor"))
            Image(systemName: player == selectedPlayer ? "chevron.left" : "chevron.right")
                .font(Font.system(size: 17, weight: .semibold))
                .foregroundColor("\(player.numberGames)" == "0" ? Color.clear : Color("AccentColor"))

        }
        .listRowBackground(Color.white)
        .onTapGesture {
            if selectedPlayer == player {
                selectedPlayer = Player()
            } else {
                selectedPlayer = player
            }
        }
        if selectedPlayer == player {
            PlayerDetailView(player: player)
        }
    }
}

#Preview {
    DetailStatsView(player: Player())
}
