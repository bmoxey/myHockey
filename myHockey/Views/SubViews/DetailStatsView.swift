//
//  DetailStatsView.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import SwiftUI

struct DetailStatsView: View {
    var player: Player
    var body: some View {
        HStack {
          if player.fillin {
              Image(systemName: "person.fill.badge.plus")
                  .foregroundColor(Color("AccentColor"))
          }
          Text(player.name)
                .foregroundStyle(Color("DarkColor"))
          if player.goalie > 0 {
              Text("(GK)")
                  .foregroundStyle(Color("DarkColor"))
          }
          if player.captain {
              Image(systemName: "star.circle")
                  .foregroundStyle(Color("AccentColor"))
          }
          if player.greenCards > 0 {
              Text(String(repeating: "▲", count: player.greenCards))
                  .font(.system(size:20))
                  .foregroundStyle(Color.green)
                  .padding(.vertical, 0)
                  .padding(.horizontal, 0)
          }
          if player.yellowCards > 0 {
              Text(String(repeating: "■", count: player.yellowCards))
                  .font(.system(size:20))
                  .foregroundStyle(Color.yellow)
                  .padding(.vertical, 0)
                  .padding(.horizontal, 0)
          }
          if player.redCards > 0 {
              Text(String(repeating: "●", count: player.redCards))
              .font(.system(size:20))
              .foregroundStyle(Color.red)
              .padding(.vertical, 0)
              .padding(.horizontal, 0)
          }
          Spacer()
//          Text("\(player.goals)")
//              .frame(width: 30)
//              .foregroundStyle(Color("DarkColor"))
          Text("\(player.numberGames)")
              .frame(width: 30)
              .foregroundStyle(Color("DarkColor"))
      }
      .lineLimit(nil)
    }
}

#Preview {
    DetailStatsView(player: Player())
}
