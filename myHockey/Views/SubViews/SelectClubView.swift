//
//  SelectClubView.swift
//  myHockey
//
//  Created by Brett Moxey on 18/4/2024.
//

import SwiftUI

struct SelectClubView: View {
    @EnvironmentObject private var teamsManager: TeamsManager
    @Environment(\.presentationMode) var presentationMode
    @Binding var teams: [Teams]
    var body: some View {
        let uniqueClubs = Array(Set(teams.map { $0.image }))
        ForEach(uniqueClubs.sorted(), id: \.self) { club in
            NavigationLink(destination: SelectTeamView(myTeam: club, teams: teams).environmentObject(teamsManager)) {
                HStack {
                    Image(GetImage(teamName: club))
                        .resizable()
                        .frame(width: 45, height: 45)
                        .padding(.vertical, -4)
                    Text(club)
                        .foregroundStyle(Color("DarkColor"))
                    Spacer()
                        .overlay(
                            Image(systemName: "chevron.right")
                                .font(Font.system(size: 17, weight: .semibold))
                                .foregroundColor(Color("AccentColor"))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.horizontal, -8)
                        )
                }
            }
            .listRowBackground(Color.white)
        }
    }
}

#Preview {
    SelectClubView(teams: .constant([]))
}
