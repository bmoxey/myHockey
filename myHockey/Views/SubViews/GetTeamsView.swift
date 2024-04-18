//
//  GetTeamsView.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import SwiftUI

struct GetTeamsView: View {
    @EnvironmentObject private var teamsManager: TeamsManager
    @Binding var myComp: Teams
    @State var teams: [Teams] = []
    var body: some View {
        Section(header: Text("Select your team").foregroundStyle(Color.white)) {
            HStack {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color("AccentColor"))
                Text(myComp.compName)
                    .foregroundStyle(Color.white)
            }
            .listRowBackground(Color("DarkColor"))
            .onTapGesture {
                teams = []
                myComp = Teams()
            }
            HStack {
                Text(myComp.type)
                Text(myComp.divName)
                    .foregroundStyle(Color("DarkColor"))
            }
            .listRowBackground(Color("AccentColor"))
            .onAppear() {
                if teams.isEmpty {
                    Task {
                        teams = []
                        teams = await getTeams(myComp: myComp)
                    }
                }
            }
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
                        if !teamsManager.myTeams.contains(where: { $0.teamID == team.teamID && $0.compID == team.compID }) {
                            if teamsManager.myTeams.isEmpty { teamsManager.currentTeam = team }
                            teamsManager.myTeams.append(team)
                            teamsManager.saveTeams()
                            myComp = Teams()
                        }
                    }
                }
            }
            .listRowBackground(Color.white)
        }
    }
}

#Preview {
    GetTeamsView(myComp: .constant(Teams()))
}
