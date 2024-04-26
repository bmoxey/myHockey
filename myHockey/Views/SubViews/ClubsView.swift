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
    @Binding var teams: [Teams]
    @Binding var useDB: Bool
    @State private var comps: [Teams] = []
    @State private var compList: [TeamSummary] = []
    @State private var searching = false
    @State private var stillLoading = false
    var body: some View {
        List {
            if !teams.isEmpty && !stillLoading {
                SelectClubView(teams: $teams, stillLoading: $stillLoading, useDB: $useDB)
                    .environmentObject(teamsManager)
            } else {
                if !compList.isEmpty {
                    SearchCompsView(teams: $teams, comps: comps, compList: compList, stillLoading: $stillLoading, useDB: $useDB)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("DarkColor").brightness(0.2))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(!teams.isEmpty && !stillLoading ? "Select your club" : "Searching ...")
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
            if !useDB {teams = []}
            if !teams.isEmpty {stillLoading = false}
            comps = await getComps()
            compList = teamsSum.teamSummary(comps).sorted(by: { $0.compName < $1.compName })
        }
    }
}

#Preview {
    ClubsView(teams: .constant([]), useDB: .constant(false))
}
