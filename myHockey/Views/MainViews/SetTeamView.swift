//
//  SetTeamView.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import SwiftUI

struct SetTeamView: View {
    @EnvironmentObject private var teamsManager: TeamsManager
    @State private var comps: [Teams] = []
    @State private var searchComp = ""
    @State private var myComp: Teams = Teams()
    var body: some View {
        NavigationView {
            List{
                CurrentTeamsView()
                    .environmentObject(teamsManager)
                if comps.isEmpty {
                    Text("Loading...")
                        .foregroundStyle(Color("DarkColor"))
                        .listRowBackground(Color.white)
                        .task {(comps, searchComp) = await getComps()}
                } else {
                    if myComp.compName == "" {
                        GetCompsView(comps: $comps, myComp: $myComp, searchComp: $searchComp)
                    } else {
                        GetTeamsView(myComp: $myComp)
                            .environmentObject(teamsManager)
                    }
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
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "person.crop.circle.badge.questionmark.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.white, Color.orange)
                        .font(.title3)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image("HVLogo")
                        .resizable()
                        .frame(width: 35, height: 35)
                }
            }
            .toolbarBackground(Color("DarkColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    SetTeamView()
}
