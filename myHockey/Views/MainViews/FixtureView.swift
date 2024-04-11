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
    @State private var myRound: Round = Round()
    @State private var myPlayers: [Player] = []
    @State var currentFixture: Fixture? = Fixture()
    @State var address: String = ""
    @State var searchTeam: String = ""
    var body: some View {
        NavigationView {
            VStack {
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
                                        fixtures = await getFixtures(teamsManager: teamsManager)
                                        try? await Task.sleep(nanoseconds: 50_000_000)
                                        let count = fixtures.filter { $0.date < Date() }.count
                                        scrollToElement(index: count)
                                        if count > 0 {
                                            currentFixture = fixtures[count-1]
                                            if currentFixture?.result != "BYE" {
                                                if currentFixture?.status == "Playing" {
                                                    address = await getGround(fixture: currentFixture ?? Fixture())
                                                } else {
                                                    (myRound, myPlayers) = await getGame(fixture: currentFixture ?? Fixture())
                                                }
                                            }
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
                        if currentFixture?.result == "BYE" {
                            BYEFixtureView(fixture: $currentFixture)
                        } else {
                            if currentFixture?.status == "Playing" {
                                UpcomingFixtureView(fixture: $currentFixture)
                                GroundView(fixture: $currentFixture, address: $address)
                            } else {
                                if myRound.homeTeam != "" {
                                    RoundSummaryView(round: $myRound)
                                    PlayersView(searchTeam: myRound.myTeam, myRound: $myRound, players: $myPlayers)
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .onChange(of: currentFixture, {
                        Task() {
                            try await Task.sleep(nanoseconds: 100_000_000)
                            if currentFixture?.result != "BYE" {
                                if currentFixture?.status == "Playing" {
                                    address = await getGround(fixture: currentFixture ?? Fixture())
                                } else {
                                    (myRound, myPlayers) = await getGame(fixture: currentFixture ?? Fixture())
                                }
                            }
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
                        Text("Team Fixture")
                            .foregroundStyle(Color.white)
                            .fontWeight(.semibold)
                        Text(teamsManager.currentTeam.divName)
                            .foregroundStyle(Color.white)
                            .font(.footnote)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "calendar.badge.clock")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.white, Color.orange)
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
