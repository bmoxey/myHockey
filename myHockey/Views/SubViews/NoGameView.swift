//
//  NoGameView.swift
//  myHockey
//
//  Created by Brett Moxey on 11/4/2024.
//

import SwiftUI

struct NoGameView: View {
    let myTeam: String
    let game: Round

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text("\(game.homeTeam)")
                        .foregroundStyle(Color("DarkColor"))
                        .fontWeight(game.homeTeam == myTeam ? .bold : .regular)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                    Spacer()
                }
                Text("vs")
                    .foregroundStyle(Color("DarkColor"))
                HStack {
                    Spacer()
                    Text("\(game.awayTeam)")
                        .foregroundStyle(Color("DarkColor"))
                        .fontWeight(game.awayTeam == myTeam ? .bold : .regular)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
            }
            HStack {
                Image(GetImage(teamName: game.homeTeam))
                    .resizable()
                    .frame(width: 75, height: 75)
                Spacer()
                DateBoxView(date: game.date, fullDate: true)
                Spacer()
                Image(GetImage(teamName: game.awayTeam))
                    .resizable()
                    .frame(width: 75, height: 75)
            }
        }
    }
}

#Preview {
    NoGameView(myTeam: "MHSOB", game: Round())
}
