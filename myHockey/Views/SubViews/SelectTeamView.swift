//
//  SelectTeamView.swift
//  myHockey
//
//  Created by Brett Moxey on 18/4/2024.
//

import SwiftUI

struct SelectTeamView: View {
    @EnvironmentObject private var teamsManager: TeamsManager
    @EnvironmentObject var pathState: PathState
    var myTeam: String
    var teams: [Teams]
    @Binding var stillLoading: Bool
    @Binding var useDB: Bool

    var body: some View {
        let filteredTeams = teams.filter { $0.image == myTeam }
        let groupedTeams = Dictionary(grouping: filteredTeams, by: { $0.type })
        
        return List {
            ForEach(Array(groupedTeams.keys).sorted(), id: \.self) { type in
                let header = "\(myTeam) \(type) teams"
                Section(header: Text(header).foregroundStyle(Color.white)) {
                    ForEach(groupedTeams[type]!, id: \.id) { club in
                        HStack {
                            Text(club.type)
                            VStack(alignment: .leading) {
                                Text(club.divName)
                                    .foregroundStyle(Color("DarkColor"))
                                if club.teamName != club.image {
                                    Text("competing as \(club.teamName)")
                                        .foregroundStyle(Color("DarkColor").opacity(0.8))
                                        .font(.footnote)
                                }
                            }
                            Spacer()
                                .overlay(
                                    Image(systemName: "chevron.right")
                                        .font(Font.system(size: 17, weight: .semibold))
                                        .foregroundColor(Color("AccentColor"))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.horizontal, -8)
                                )
                        }
                        .listRowBackground(Color.white)
                        .onTapGesture {
                            teamsManager.currentTeam = club
                            if !teamsManager.myTeams.contains(where: { $0.teamID == club.teamID && $0.compID == club.compID }) {
                                teamsManager.myTeams.append(club)
                            }
                            teamsManager.saveTeams()
                            pathState.path = []
                        }

                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("DarkColor").brightness(0.2))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Select your team")
                        .foregroundStyle(Color.white)
                        .fontWeight(.semibold)
                    Text(myTeam)
                        .foregroundStyle(Color.white)
                        .font(.footnote)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(myTeam)
                    .resizable()
                    .frame(width: 35, height: 35)
            }
        }
        .toolbarBackground(Color("DarkColor"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    SelectTeamView(myTeam: "", teams: [], stillLoading: .constant(false), useDB: .constant(true))
}
