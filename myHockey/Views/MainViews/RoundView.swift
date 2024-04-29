//
//  RoundView.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import SwiftUI

struct RoundView: View {
    @ObservedObject private var teamsManager = TeamsManager()
    @State private var rounds: [Rounds] = []
    @State private var haveData = false
    @State private var myRound: [Round] = []
    @State private var byeTeams: [String] = []
    @State var currentRound: Rounds?
    @State var searchTeam: String = ""
    @State var count: Int = 0
    @State private var showModifierDialog = false
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if rounds.isEmpty {
                    if teamsManager.currentTeam == Teams() {
                        CenterTextView(text: "No Team Selected")
                    } else {
                        if haveData {
                            CenterTextView(text: "No Data")
                        } else {
                            CenterTextView(text: "Loading...")
                                .onAppear {
                                    Task {
                                        rounds = await getRounds(teamsManager: teamsManager)
                                        try? await Task.sleep(nanoseconds: 50_000_000)
                                        count = 0
                                        for round in rounds {
                                            if round.lastdate < Date() { count += 1 }
                                        }
                                        if count > rounds.count - 1 { count = rounds.count - 1}
                                        scrollToElement(index: count)
                                        haveData = true
                                    }
                                }
                        }
                    }
                } else {
                    VStack {
                        RoundSelectionView(rounds: $rounds, currentRound: $currentRound)
                        RoundListView(rounds: $rounds, currentRound: $currentRound)
                    }
                    .background(Color.white)
                    List {
                        ForEach(groupedRounds, id: \.0) { date, roundsInSection in
                            Section(header: Text(dateString(from: date)).foregroundStyle(Color.white)) {
                                ForEach(roundsInSection) { game in
                                    GameView(myTeam: teamsManager.currentTeam.teamName, game: game)
                                        .listRowBackground(Color.white)
                                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                                }
                            }
                        }
                        if !byeTeams.isEmpty {
                            Section(header: Text("No game this round").foregroundStyle(Color.white)) {
                                ForEach(byeTeams, id: \.self) { team in
                                    ByeView(myTeam: teamsManager.currentTeam.teamName, team: team)
                                        .listRowBackground(Color.white)
                                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .onChange(of: currentRound, {
                        Task() {
                            try await Task.sleep(nanoseconds: 100_000_000)
                            if currentRound?.result != "BYE" {
                                (myRound, byeTeams) = await getRound(teamsManager: teamsManager, currentRound: currentRound!)
                            }
                        }
                    })
                }
            }
            .onAppear {
                rounds = []
                haveData = false
            }
            .background(Color("DarkColor").brightness(0.2))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        HStack {
                            Text("Round by round")
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
                        rounds = []
                        showModifierDialog = false
                    }
                    .padding(.horizontal, -8)
            }
            .scrollContentBackground(.hidden)
            .background(Color("DarkColor").brightness(0.2))
        }

    }
    
    func scrollToElement(index: Int) {
        guard index < rounds.count else { return }
        DispatchQueue.main.async {
            currentRound = rounds[index]
        }
    }
    
    var groupedRounds: [(Date, [Round])] {
        let groupedDictionary = Dictionary(grouping: myRound) { game in
            Calendar.current.startOfDay(for: game.date)
        }
        return groupedDictionary.sorted { $0.key < $1.key }
    }
    
    // Helper functions to format date and time strings
    func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
    
    func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct RoundView_Previews: PreviewProvider {
    static var previews: some View {
        RoundView()
    }
}

#Preview {
    RoundView()
}
