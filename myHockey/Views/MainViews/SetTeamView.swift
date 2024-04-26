//
//  SetTeamView.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import SwiftUI

struct SetTeamView: View {
    @EnvironmentObject private var teamsManager: TeamsManager
    @StateObject private var teamsSum = TeamsSum()
    @StateObject var pathState = PathState()
    @State var currentTeamID = ""
    @State private var teams: [Teams] = []
    @State private var useDB: Bool = false
    var body: some View {
        NavigationStack(path: $pathState.path) {
            List{
                Section(header: Text("My Teams").foregroundStyle(Color.white)) {
                    ForEach(teamsManager.myTeams, id: \.id) { team in
                        HStack {
                            Image(team.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .padding(.vertical, -8)
                            VStack {
                                HStack {
                                    Text(team.divName)
                                        .foregroundStyle(Color("DarkColor"))
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                HStack {
                                    Text(team.teamName)
                                        .foregroundStyle(Color("DarkColor").opacity(0.8))
                                    Spacer()
                                }
                            }
                        }
                        .listRowBackground(currentTeamID == team.teamID ? Color.orange : Color.white)
                        .onTapGesture {
                            teamsManager.currentTeam = team
                            teamsManager.saveTeams()
                            currentTeamID = teamsManager.currentTeam.teamID
                        }
                    }
                    .onDelete { indexSet in
                        let teams = teamsManager.myTeams
                        for index in indexSet {
                            if teams[index].teamID == teamsManager.currentTeam.teamID {
                                if let newSelectedTeam = teams.first(where: { $0.teamID != teams[index].teamID }) {
                                    teamsManager.currentTeam = newSelectedTeam
                                    teamsManager.saveTeams()
                                } else {
                                    teamsManager.currentTeam = Teams()
                                    teamsManager.saveTeams()
                                }
                            }
                        }
                        teamsManager.myTeams.remove(atOffsets: indexSet)
                        teamsManager.saveTeams()
                        currentTeamID = teamsManager.currentTeam.teamID
                    }
                }
                Section (header: Text("Add teams...").foregroundStyle(Color.white)) {
                    NavigationLink(value: PathState.Destination.getComps) {
                        HStack {
                            Image(systemName: "rectangle.stack.badge.plus")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.white, Color.orange)
                            Text("Add by competition (quick)")
                                .foregroundStyle(Color.white)
                        }
                    }
                    .listRowBackground(Color("DarkColor"))
                    .foregroundStyle(.white, .orange)
                }
                Section {
                    NavigationLink(value: PathState.Destination.getClubs) {
                        HStack {
                            Image(systemName: "person.crop.rectangle.badge.plus")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.white, Color.orange)
                            Text(teams.isEmpty || !useDB ? "Add by club name (slow)" : "Add by club name (quick)")
                                .foregroundStyle(Color.white)
                        }
                    }
                    .listRowBackground(Color("DarkColor"))
                    .foregroundStyle(.white, .orange)
                    if !teams.isEmpty {
                        HStack {
                            Image(systemName: "externaldrive.fill.badge.person.crop")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.white, Color.orange)
                            Spacer()
                            Toggle("Use existing club database?", isOn: $useDB)
                        }
                        .listRowBackground(Color("DarkColor"))
                        .foregroundStyle(.white, .orange)
                    }

                }
            }
            .navigationDestination(for: PathState.Destination.self) { destination in
                switch destination {
                    case .getComps: CompsView()
                        .environmentObject(teamsManager)
                    case .getClubs: ClubsView(teams: $teams, useDB: $useDB)
                        .environmentObject(teamsManager)
                        .environmentObject(TeamsSum())
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("DarkColor").brightness(0.2))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Select Your Team")
                            .foregroundStyle(Color.white)
                            .fontWeight(.semibold)
                        Text(teamsManager.currentTeam.divName)
                            .foregroundStyle(Color.white)
                            .font(.footnote)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "person.crop.circle.badge.questionmark.fill")
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
            .task {
                currentTeamID = teamsManager.currentTeam.teamID
            }
        }
        .environmentObject(pathState)
        .onAppear {
            teamsManager.loadTeams()
            if !teams.isEmpty { useDB = true }
        }
        .accentColor(Color.orange)
    }
}

#Preview {
    SetTeamView()
}
