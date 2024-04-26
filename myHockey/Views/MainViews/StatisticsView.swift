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
    @State private var showModifierDialog = false
    var body: some View {
        NavigationStack {
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
                            DetailStatsView(player: player)
                            
                        }
                    }.environment(\.defaultMinListRowHeight, 12)
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
                        HStack {
                            Text("Player Statistics")
                                .foregroundStyle(Color.white)
                                .fontWeight(.semibold)
                            if teamsManager.myTeams.count > 1 {
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color.orange)
                            }
                        }
                        Text(teamsManager.currentTeam.divName)
                            .foregroundStyle(Color.white)
                            .font(.footnote)
                    }
                    .onTapGesture {
                        if teamsManager.myTeams.count > 1 {
                            withAnimation {
                                showModifierDialog = true
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "calendar.badge.clock")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.white, Color.orange)
                        .font(.title3)
                        .onTapGesture {
                            if teamsManager.myTeams.count > 1 {
                                withAnimation {
                                    showModifierDialog = true
                                }
                            }
                        }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(teamsManager.currentTeam.image == "" ? "HVLogo" : teamsManager.currentTeam.image)
                        .resizable()
                        .frame(width: 35, height: 35)
                        .onTapGesture {
                            if teamsManager.myTeams.count > 1 {
                                withAnimation {
                                    showModifierDialog = true
                                }
                            }
                        }
                }
            }
            .toolbarBackground(Color("DarkColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .customConfirmDialog(isPresented: $showModifierDialog) {
            List {
                CurrentTeamsView()
                    .environmentObject(teamsManager)
                    .onChange(of: teamsManager.currentTeam.teamID) { oldValue, newValue in
                        teamsManager.saveTeams()
                        haveData = false
                        players = []
                        showModifierDialog = false
                    }
                    .padding(.horizontal, -8)
            }
            .scrollContentBackground(.hidden)
            .background(Color("DarkColor").brightness(0.2))
        }

        .tint(.orange)
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
