//
//  ItemDetailView.swift
//  myHockey
//
//  Created by Brett Moxey on 23/4/2024.
//

import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject private var teamsManager: TeamsManager
    var item: LadderItem
    var maxScore: Int
    var body: some View {
        let maxScoreWidth = Int(UIScreen.main.bounds.width * 5 / 9)
        let maxResultWidth = Int(UIScreen.main.bounds.width * 3 / 4)
        VStack {
            HStack {
                Text("Goals")
                    .fontWeight(.bold)
                Spacer()
                Text("For:")
                if (item.scoreFor * maxScoreWidth / maxScore < 20) {
                    Text("\(item.scoreFor)")
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: CGFloat(item.scoreFor * maxScoreWidth / maxScore), height: 20)
                } else {
                    Text("\(item.scoreFor)")
                        .frame(width: CGFloat(item.scoreFor * maxScoreWidth / maxScore), height: 20)
                        .background(.green)
                }
            }
            .padding(.bottom, -4)
            HStack {
                Text("Diff:")
                Text(" \(item.diff) ")
                    .background(item.diff == 0 ? Color.yellow : item.diff > 0 ? Color.green : Color.red)
                    .fontWeight(.semibold)
                Spacer()
                Text("Agst:")
                if (item.scoreAgainst * maxScoreWidth / maxScore < 20) {
                    Text("\(item.scoreAgainst)")
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: CGFloat(item.scoreAgainst * maxScoreWidth / maxScore), height: 20)
                } else {
                    Text("\(item.scoreAgainst)")
                        .frame(width: CGFloat(item.scoreAgainst * maxScoreWidth / maxScore), height: 20)
                        .background(.red)
                }
            }
            .padding(.top, -4)
        }
        .foregroundStyle(Color("DarkColor"))
        .font(.subheadline)
        .listRowBackground(Color("DarkColor").brightness(0.75))
        .frame(height: 12)
        HStack(spacing: 0) {
            Spacer()
            if item.wins > 0 {
                VStack {
                    Text(item.wins * maxResultWidth / (item.played + item.byes) < 50 ? "W" : "Wins")
                        .padding(.bottom, -4)
                    Text("\(item.wins)")
                        .frame(width: CGFloat(item.wins * maxResultWidth / (item.played + item.byes)), height: 20)
                        .background(.green)
                        .padding(.top, -4)
                }
            }
            if item.draws > 0 {
                VStack {
                    Text(item.draws * maxResultWidth / (item.played + item.byes) < 60 ? "D" : "Draws")
                        .padding(.bottom, -4)
                    Text("\(item.draws)")
                        .frame(width: CGFloat(item.draws * maxResultWidth / (item.played + item.byes)), height: 20)
                        .background(.yellow)
                        .padding(.top, -4)
                }
            }
            if item.losses > 0 {
                VStack {
                    Text(item.losses * maxResultWidth / (item.played + item.byes) < 50 ? "L" : "Loss")
                        .padding(.bottom, -4)
                    Text("\(item.losses)")
                        .frame(width: CGFloat(item.losses * maxResultWidth / (item.played + item.byes)), height: 20)
                        .background(.red)
                        .padding(.top, -4)
                }
            }
            if item.byes > 0 {
                VStack {
                    Text(item.byes * maxResultWidth / (item.played + item.byes) < 40 ? "B" : "Bye")
                        .padding(.bottom, -4)
                    Text("\(item.byes)")
                        .frame(width: CGFloat(item.byes * maxResultWidth / (item.played + item.byes)), height: 20)
                        .background(.cyan)
                        .padding(.top, -4)
                }
            }
            Spacer()
        }
        .foregroundStyle(Color("DarkColor"))
        .font(.subheadline)
        .listRowBackground(Color("DarkColor").brightness(0.75))
        .frame(height: 12)
        HStack {
            HStack {
                Text("Played:")
                    .foregroundStyle(Color.white)
                    .font(.subheadline)
                Text("\(item.played)")
                        .foregroundStyle(Color.orange)
                        .font(.subheadline)
                Spacer()
            }
            Text("Points:")
                .foregroundStyle(Color.white)
                .font(.subheadline)
            Text("\(item.points)")
                .foregroundStyle(Color.orange)
                .font(.subheadline)
            HStack {
                Spacer()
                Text("WR:")
                    .foregroundStyle(Color.white)
                    .font(.subheadline)
                Text(item.winRatio)
                    .foregroundStyle(Color.orange)
                    .font(.subheadline)
            }
        }
        .frame(height: 12)
        .listRowBackground(Color("DarkColor").brightness(0.1))
    }
}

