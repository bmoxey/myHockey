//
//  StatisticsView.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import SwiftUI

struct StatisticsView: View {
    @ObservedObject private var teamsManager = TeamsManager()
    @State var haveData = false
    @State var players = [Player]()
    @State private var sortedByName = true
    @State private var sortedByNameValue: KeyPath<Player, String> = \Player.surname
    @State private var sortedByValue: KeyPath<Player, Int>? = nil
    @State private var sortAscending = true
    @State private var sortMode = 2
    var body: some View {
        NavigationView {
            VStack {
                if players.isEmpty {
                    if teamsManager.currentTeam == Teams() {
                        CenterTextView(text: "No Team Selected")
                    } else {
                        if haveData {
                            CenterTextView(text: "No Data")
                        } else {
                            CenterTextView(text: "Loading...")
                                .onAppear {
                                    Task {
                                        players = await getPlayerStats(teamsManager: teamsManager)
                                        try? await Task.sleep(nanoseconds: 50_000_000)
                                        haveData = true
                                    }
                                }
                        }
                    }
                } else {
                    List {
                        DetailHeaderStatsView(sortMode: $sortMode, sortAscending: $sortAscending, sortedByName: $sortedByName, sortedByNameValue: $sortedByNameValue, sortedByValue: $sortedByValue)
                            .listRowBackground(Color("DarkColor"))
                        ForEach(players.sorted(by: sortDescriptor)) { player in
                            //                    NavigationLink(destination: PlayerStatsView(myTeam: currentTeam.teamName, myTeamID: currentTeam.teamID, myCompID: currentTeam.compID,  player: player)) {
                            DetailStatsView(player: player)
                            //                    }
                                .listRowBackground(Color.white)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .onAppear {
                players = []
                haveData = false
            }
            .background(Color("DarkColor").brightness(0.2))
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Player Statistics")
                            .foregroundStyle(Color.white)
                            .fontWeight(.semibold)
                        Text(teamsManager.currentTeam.divName)
                            .foregroundStyle(Color.white)
                            .font(.footnote)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "chart.bar.xaxis")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.orange, Color.white)
                        .font(.title3)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(teamsManager.currentTeam.image == "" ? "HVLogo" : teamsManager.currentTeam.image)
                        .resizable()
                        .frame(width: 35, height: 35)
                }
            }
            .toolbarBackground(Color("DarkColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    private var sortDescriptor: (Player, Player) -> Bool {
        let ascending = sortAscending
        if let sortedByValue = sortedByValue {
            return { (player1, player2) in
                if ascending {
                    return player1[keyPath: sortedByValue] < player2[keyPath: sortedByValue]
                } else {
                    return player1[keyPath: sortedByValue] > player2[keyPath: sortedByValue]
                }
            }
        } else if sortedByName {
            return { (player1, player2) in
                if ascending {
                    return player1[keyPath: sortedByNameValue] < player2[keyPath: sortedByNameValue]
                } else {
                    return player1[keyPath: sortedByNameValue] > player2[keyPath: sortedByNameValue]
                }
            }
        } else {
            return { _, _ in true }
        }
    }
}

#Preview {
    StatisticsView()
}
