//
//  ClubsView.swift
//  myHockey
//
//  Created by Brett Moxey on 18/4/2024.
//

import SwiftUI

struct ClubsView: View {
    @EnvironmentObject private var teamsManager: TeamsManager
    @EnvironmentObject private var teamsSum: TeamsSum
    @Environment(\.presentationMode) var presentationMode
    @State private var teams: [Teams] = []
    @State private var comps: [Teams] = []
    @State private var compList: [TeamSummary] = []
    @State private var searching = false
    @State private var stillLoading = true
    var body: some View {
        List {
            if !compList.isEmpty {
                if !searching {
                    SelectCompsView(comps: $comps, compList: $compList, searching: $searching)
                } else {
                    if stillLoading {
                        SearchCompsView(teams: $teams, comps: comps, compList: compList, stillLoading: $stillLoading)
                    } else {
                        SelectClubView(teams: $teams)
                            .environmentObject(teamsManager)
                    }
                }
                
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("DarkColor").brightness(0.2))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(searching ? stillLoading ? "Searching..." : "Select your club" : "Search comps for clubs")
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
            if teamsManager.change {
                teamsManager.change = false
                teamsManager.saveTeams()
                self.presentationMode.wrappedValue.dismiss()
            }
            comps = await getComps()
            compList = teamsSum.teamSummary(comps).sorted(by: { $0.compName < $1.compName })
        }
    }
}

#Preview {
    ClubsView()
}
