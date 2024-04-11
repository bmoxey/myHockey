//
//  GameView.swift
//  myHockey
//
//  Created by Brett Moxey on 11/4/2024.
//

import SwiftUI

struct GameView: View {
    let myTeam: String
    let game: Round
    var body: some View {
        VStack {
            if game.message != "" {
                HStack {
                    Spacer()
                    Text("\(game.message)")
                        .foregroundStyle(Color(.purple))
                    Spacer()
                }
            }
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
                VStack {
                    HStack {
                        Text("\(game.homeGoals)")
                            .foregroundStyle(Color("DarkColor"))
                            .fontWeight(game.homeTeam == myTeam ? .bold : .regular)
                            .font(.largeTitle)
                        Spacer()
                        Text(" \(game.result) ")
                            .foregroundStyle(Color("DarkColor"))
                            .font(.title3)
                        Spacer()
                        Text("\(game.awayGoals)")
                            .font(.largeTitle)
                            .fontWeight(game.awayTeam == myTeam ? .bold : .regular)
                            .foregroundStyle(Color("DarkColor"))
                    }
                }
                Image(GetImage(teamName: game.awayTeam))
                    .resizable()
                    .frame(width: 75, height: 75)
            }
        }
    }
}

#Preview {
    GameView(myTeam: "MHSOB", game: Round())
}
