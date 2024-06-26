//
//  PlayerView.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import SwiftUI

struct PlayerView: View {
    var player: Player
    var body: some View {
        HStack {
            if player.fillin {
                Image(systemName: "person.fill.badge.plus")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("DarkColor"), Color.orange)
            } else {
                if player.captain {
                    Image(systemName: "person.wave.2.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.orange, Color("DarkColor"))
                } else {
                    Image(systemName: "person.fill")
                        .foregroundStyle(Color.orange)
                }
            }
            Text(player.name)
                .foregroundStyle(Color("DarkColor"))
            if player.goalie == 1 {
                Text("(GK)")
                    .foregroundStyle(Color("DarkColor"))
            }
            if player.greenCards > 0 {
                Text(String(repeating: "▲", count: player.greenCards))
                    .font(.system(size:24))
                    .foregroundStyle(Color.green)
                    .padding(.vertical, 0)
                    .padding(.horizontal, 0)
            }
            if player.yellowCards > 0 {
                Text(String(repeating: "■", count: player.yellowCards))
                    .font(.system(size:24))
                    .foregroundStyle(Color.yellow)
                    .padding(.vertical, 0)
                    .padding(.horizontal, 0)
            }
            if player.redCards > 0 {
                Text(String(repeating: "●", count: player.redCards))
                .font(.system(size:24))
                .foregroundStyle(Color.red)
                .padding(.vertical, 0)
                .padding(.horizontal, 0)
            }
            Spacer()
            if player.goals > 0 {
                Text(String(repeating: "●", count: player.goals))
                .font(.system(size:20))
                .foregroundStyle(Color.green)
                .padding(.vertical, 0)
                .padding(.horizontal, 0)
            }
        }
        .listRowBackground(Color.white)
    }
}

#Preview {
    PlayerView(player: Player())
}
