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
    var myTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: game.date)
    }
    var body: some View {
        HStack {
            HStack {
                Spacer()
                VStack {
                    Image(GetImage(teamName: game.homeTeam))
                        .resizable()
                        .frame(width: 75, height: 75)
                    Text("\(game.homeTeam)")
                        .foregroundStyle(Color("DarkColor"))
                        .fontWeight(game.homeTeam == myTeam ? .bold : .regular)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
                Spacer()
            }
            HStack {
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "sportscourt")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 15)
                            .foregroundStyle(Color("DarkColor"))
                        Text("\(game.field)")
                            .foregroundStyle(Color("DarkColor"))
                    }
                    if game.result == "No Game" {
                        DateBoxView(date: game.date, fullDate: false)
                    } else {
                        HStack {
                            Text("\(game.homeGoals)")
                                .foregroundStyle(Color("DarkColor"))
                                .fontWeight(game.homeTeam == myTeam ? .bold : .regular)
                                .font(.largeTitle)
                            Text(game.result == "No Results" ? myTime : "-")
                                .foregroundStyle(Color("DarkColor"))
                            Text("\(game.awayGoals)")
                                .font(.largeTitle)
                                .fontWeight(game.awayTeam == myTeam ? .bold : .regular)
                                .foregroundStyle(Color("DarkColor"))
                        }
                        Text(" \(game.result) ")
                            .foregroundStyle(Color("DarkColor"))
                            .background(getColor(result: game.result))
                    }
                }
            }
            HStack {
                Spacer()
                VStack {
                    Image(GetImage(teamName: game.awayTeam))
                        .resizable()
                        .frame(width: 75, height: 75)
                    Text("\(game.awayTeam)")
                        .foregroundStyle(Color("DarkColor"))
                        .fontWeight(game.awayTeam == myTeam ? .bold : .regular)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
                Spacer()
            }
        }
        .listRowBackground(getColor(result: game.result).brightness(0.60))
        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
}

#Preview {
    GameView(myTeam: "MHSOB", game: Round())
}
