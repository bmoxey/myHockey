//
//  CurrentTeamsView.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import SwiftUI

struct CurrentTeamsView: View {
    @EnvironmentObject private var teamsManager: TeamsManager
     var body: some View {
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
                 .listRowBackground(teamsManager.currentTeam.teamID == team.teamID ? Color.orange : Color.white)
                 .onTapGesture {
                     teamsManager.currentTeam = team
                     teamsManager.saveTeams()
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
             }
         }
     }
}

#Preview {
    CurrentTeamsView()
}
