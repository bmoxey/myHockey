//
//  LadderView.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import SwiftUI

struct LadderView: View {
    @ObservedObject private var teamsManager = TeamsManager()
    @State var haveData = false
    @State var ladder = [LadderItem]()
    @State private var showModifierDialog = false
    @State private var ladderMode = "Summary"
    @State private var ladderModes: [String] = ["Summary","Detailed"]
    var body: some View {
        let maxScore = ladder.map { max($0.scoreFor, $0.scoreAgainst) }.max() ?? 0
        NavigationView {
            VStack(spacing: 0) {
                if ladder.isEmpty {
                    if teamsManager.currentTeam == Teams() {
                        CenterTextView(text: "No Team Selected")
                    } else {
                        if haveData {
                            CenterTextView(text: "No Data")
                        } else {
                            CenterTextView(text: "Loading...")
                                .onAppear {
                                    Task {
                                        ladder = await getLadder(teamsManager: teamsManager)
                                        try? await Task.sleep(nanoseconds: 50_000_000)
                                        haveData = true
                                    }
                                }
                        }
                    }
                } else {
                    List {
                        Picker("Mode:", selection: $ladderMode) {
                            ForEach(ladderModes, id:\.self) {mode in
                                    Text(mode)
                                    .tag(mode)
                            }
                        }
                        .onAppear {
                            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.orange)
                            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color("DarkColor"))], for: .selected)
                            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.orange)], for: .normal)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .listRowBackground(Color("DarkColor"))
                        DetailLadderHeaderView(mode: $ladderMode)
                            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                            .listRowBackground(Color("DarkColor"))
                        ForEach(ladder.indices, id: \.self) { index in
                            let item = ladder[index]
                            DetailLadderView(mode: $ladderMode, myTeam: teamsManager.currentTeam.teamName, item: item, maxScore: maxScore)
                                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                                .listRowBackground(Color.white)
                                .listRowSeparatorTint( item.pos == 4 ? Color("DarkColor") : Color(UIColor.separator), edges: .all)
                                .listRowSeparator(item.pos == 4 ? .visible : .automatic, edges: .all)
                            
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .refreshable {
                        Task {
                            ladder = await getLadder(teamsManager: teamsManager)
                            haveData = true
                        }
                    }
                }
            }
            .onAppear {
                ladder = []
                haveData = false
            }
            .background(Color("DarkColor").brightness(0.2))

            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        HStack {
                            Text("Current Ladder")
                                .foregroundStyle(Color.white)
                                .fontWeight(.semibold)
                            if teamsManager.myTeams.count > 1 {
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color.orange)
                            }
                        }
                        Text(teamsManager.currentTeam.divName)
                            .foregroundStyle(Color.white)
                            .font(.footnote)
                    }
                    .onTapGesture {
                        if teamsManager.myTeams.count > 1 {
                            withAnimation {
                                showModifierDialog = true
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "calendar.badge.clock")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.white, Color.orange)
                        .font(.title3)
                        .onTapGesture {
                            if teamsManager.myTeams.count > 1 {
                                withAnimation {
                                    showModifierDialog = true
                                }
                            }
                        }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(teamsManager.currentTeam.image == "" ? "HVLogo" : teamsManager.currentTeam.image)
                        .resizable()
                        .frame(width: 35, height: 35)
                        .onTapGesture {
                            if teamsManager.myTeams.count > 1 {
                                withAnimation {
                                    showModifierDialog = true
                                }
                            }
                        }
                }
            }
            .toolbarBackground(Color("DarkColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .customConfirmDialog(isPresented: $showModifierDialog) {
            List {
                CurrentTeamsView()
                    .environmentObject(teamsManager)
                    .onChange(of: teamsManager.currentTeam.teamID) { oldValue, newValue in
                        teamsManager.saveTeams()
                        haveData = false
                        ladder = []
                        showModifierDialog = false
                    }
                    .padding(.horizontal, -8)
            }
            .scrollContentBackground(.hidden)
            .background(Color("DarkColor").brightness(0.2))
        }

    }
}

#Preview {
    LadderView()
}
