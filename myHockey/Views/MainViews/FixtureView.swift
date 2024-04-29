//
//  FixtureView.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import SwiftUI

struct FixtureView: View {
    @ObservedObject private var teamsManager = TeamsManager()
    @State private var fixtures: [Fixture] = []
    @State private var haveData = false
    @State private var haveRound = false
    @State private var myRound: Round = Round()
    @State private var myPlayers: [Player] = []
    @State var currentFixture: Fixture? = Fixture()
    @State var address: String = ""
    @State var searchTeam: String = ""
    @State private var isPresented = false
    @State private var showModifierDialog = false
    let buttonTitles = ["Option 1", "Option 2", "Option 3"]
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if fixtures.isEmpty {
                    if teamsManager.currentTeam == Teams() {
                        CenterTextView(text: "No Team Selected")
                    } else {
                        if haveData {
                            CenterTextView(text: "No Data")
                        } else {
                            CenterTextView(text: "Loading...")
                                .onAppear {
                                    Task {
                                        haveRound = false
                                        fixtures = await getFixtures(teamsManager: teamsManager)
                                        try? await Task.sleep(nanoseconds: 50_000_000)
                                        let count = fixtures.filter { $0.date < Date() }.count
                                        scrollToElement(index: count)
                                        if count > 0 {
                                            currentFixture = fixtures[count-1]
                                        }
                                        haveData = true
                                    }
                                }
                        }
                    }
                } else {
                    VStack {
                        FixtureSelectionView(fixtures: $fixtures, currentFixture: $currentFixture)
                        FixtureListView(fixtures: $fixtures, currentFixture: $currentFixture)
                    }
                    .background(Color.white)
                    List {
                        if haveRound {
                            if currentFixture?.result == "BYE" {
                                ByeHeaderView()
                                ByeView(myTeam: currentFixture?.myTeam ?? "", team: currentFixture?.myTeam ?? "")
                            } else {
                                if currentFixture?.status == "Playing" {
                                    Section(header: Text("\(formattedDate(currentFixture?.date ?? Date()))").foregroundStyle(Color.white)) {
                                        UpcomingFixtureView(fixture: $currentFixture)
                                        GameView(myTeam: currentFixture?.myTeam ?? "", game: myRound)
                                    }
                                    GroundView(fixture: currentFixture, address: myRound.address)
                                } else {
                                    if myRound.homeTeam != "" {
                                        Section(header: Text("\(formattedDate(currentFixture?.date ?? Date()))").foregroundStyle(Color.white)) {
                                            GameResultView(game: myRound)
                                            GameView(myTeam: currentFixture?.myTeam ?? "", game: myRound)
                                        }
                                        PlayersView(searchTeam: myRound.myTeam, myRound: $myRound, players: $myPlayers)
                                    }
                                }
                            }
                        }
                    }
                    .environment(\.defaultMinListRowHeight, 12)
                    .scrollContentBackground(.hidden)
                    .onChange(of: currentFixture, {
                        Task() {
                            haveRound = false
                            if currentFixture?.result != "BYE" {
                                (myRound, myPlayers) = await getGame(fixture: currentFixture ?? Fixture())
                            }
                            haveRound = true
                        }
                    })
                }
            }
            .onAppear {
                fixtures = []
                haveData = false
            }
            .background(Color("DarkColor").brightness(0.2))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        HStack {
                            Text("Team Fixture")
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
                        fixtures = []
                        showModifierDialog = false
                    }
                    .padding(.horizontal, -8)
            }
            .scrollContentBackground(.hidden)
            .background(Color("DarkColor").brightness(0.2))
        }
    }
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func scrollToElement(index: Int) {
        guard index < fixtures.count else { return }
        DispatchQueue.main.async {
            currentFixture = fixtures[index]
        }
    }
}

#Preview {
    FixtureView()
}

