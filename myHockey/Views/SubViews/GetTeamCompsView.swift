//
//  GetTeamCompsView.swift
//  myHockey
//
//  Created by Brett Moxey on 18/4/2024.
//

import SwiftUI

struct GetTeamCompsView: View {
    @EnvironmentObject private var teamsManager: TeamsManager
    @EnvironmentObject var pathState: PathState
    @State var myComp: Teams
    @State var teams: [Teams] = []
    var body: some View {
        List {
            if !teams.isEmpty {
                HStack {
                    Spacer()
                    Text(myComp.type)
                    Text(myComp.divName)
                        .foregroundStyle(Color.white)
                    Spacer()
                }
                .listRowBackground(Color("DarkColor"))
                
                LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], spacing: 10) {
                    ForEach(teams, id: \.id) { team in
                        VStack {
                            Image(team.image)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal)
                            Text(team.teamName)
                                .font(.footnote)
                                .foregroundStyle(Color("DarkColor"))
                                .multilineTextAlignment(.center)
                        }
                        .onTapGesture {
                            teamsManager.currentTeam = team
                            if !teamsManager.myTeams.contains(where: { $0.teamID == team.teamID && $0.compID == team.compID }) {
                                teamsManager.myTeams.append(team)
                            }
                            teamsManager.saveTeams()
                            pathState.path = []
                        }
                    }
                }
                .listRowBackground(Color.white)
            }

        }
        .scrollContentBackground(.hidden)
        .background(Color("DarkColor").brightness(0.2))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Select Your Team")
                    .foregroundStyle(Color.white)
                    .fontWeight(.semibold)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image("HVLogo")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
        }
        .toolbarBackground(Color("DarkColor"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .task {
            teams = await getTeams(myComp: myComp)
        }
    }
}

#Preview {
    GetTeamCompsView(myComp: Teams())
}
