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
    var body: some View {
        NavigationView {
            VStack {
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
                        DetailLadderHeaderView()
                            .listRowBackground(Color("DarkColor"))
                        ForEach(ladder.indices, id: \.self) { index in
                            let item = ladder[index]
                            DetailLadderView(myTeam: teamsManager.currentTeam.teamName, item: item)
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
                        Text("Current Ladder")
                            .foregroundStyle(Color.white)
                            .fontWeight(.semibold)
                        Text(teamsManager.currentTeam.divName)
                            .foregroundStyle(Color.white)
                            .font(.footnote)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "list.number")
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
        }
    }
}

#Preview {
    LadderView()
}
