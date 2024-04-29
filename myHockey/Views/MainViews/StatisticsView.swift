//
//  StatisticsView.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import SwiftUI

struct StatisticsView: View {
    @ObservedObject private var teamsManager = TeamsManager()
    @State var haveData = false
    @State private var players: [Player] = []
    @State private var sortedByName = true
    @State private var sortedByNameValue: KeyPath<Player, String> = \Player.surname
    @State private var sortedByValue: KeyPath<Player, Int>? = nil
    @State private var sortAscending = true
    @State private var sortMode = 2
    @State private var showModifierDialog = false
    @State private var count = 0
    @State private var total = 0
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                if players.isEmpty {
                    if teamsManager.currentTeam == Teams() {
                        CenterTextView(text: "No Team Selected")
                    } else {
                        if haveData {
                            CenterTextView(text: "No Data")
                        } else {
                            CenterTextView(text: "Loading...")
                        }
                    }
                } else {
                    List {
                        if !haveData {
                            HStack(alignment: .center, spacing: 0) {
                                Text("Loading ... ")
                                    .foregroundStyle(Color.white)
                                Text("\(count)")
                                    .foregroundStyle(Color.orange)
                                Text(" of ")
                                    .foregroundStyle(Color.white)
                                Text("\(total)")
                                    .foregroundStyle(Color.orange)
                                GeometryReader { geometry in
                                    HStack(spacing: 0) {
                                        let maxWidth = Int(geometry.size.width - 20)
                                        Spacer()
                                        Rectangle()
                                            .fill(.orange)
                                            .frame(width: CGFloat(count * maxWidth / total), height: 20)
                                            .padding(.all, 0)
                                        Rectangle()
                                            .fill(Color.white.opacity(0.2))
                                            .frame(width: CGFloat((total - count) * maxWidth / total), height: 20)
                                            .padding(.all, 0)
                                        Spacer()
                                    }
                                    .frame(height: 40)
                                }
                                .frame(maxHeight: .infinity)
                            }
                            .listRowBackground(Color("DarkColor"))
                        }
                        DetailHeaderStatsView(sortMode: $sortMode, sortAscending: $sortAscending, sortedByName: $sortedByName, sortedByNameValue: $sortedByNameValue, sortedByValue: $sortedByValue)
                            .listRowBackground(Color("DarkColor"))
                        ForEach(players.sorted(by: sortDescriptor)) { player in
                            DetailStatsView(player: player)
                                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                                
                        }
                    }.environment(\.defaultMinListRowHeight, 12)
                    .scrollContentBackground(.hidden)
                }
            }
            
            .onAppear {
                players = []
                haveData = false
                Task {
                    await getPlayers()
                    haveData = true
    //                                        players = await getPlayerStats(teamsManager: teamsManager)
                }
            }
            .background(Color("DarkColor").brightness(0.2))
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        HStack {
                            Text("Player Statistics")
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
                        players = []
                        haveData = false
                        Task {
                            await getPlayers()
                            haveData = true
                        }
                        showModifierDialog = false
                    }
                    .padding(.horizontal, -8)
            }
            .scrollContentBackground(.hidden)
            .background(Color("DarkColor").brightness(0.2))
        }
        .tint(.orange)
    }
    private var sortDescriptor: (Player, Player) -> Bool {
        let ascending = sortAscending
        if let sortedByValue = sortedByValue {
            return { (player1, player2) in
                if ascending {
                    return player1[keyPath: sortedByValue] < player2[keyPath: sortedByValue]
                } else {
                    return player1[keyPath: sortedByValue] > player2[keyPath: sortedByValue]
                }
            }
        } else if sortedByName {
            return { (player1, player2) in
                if ascending {
                    return player1[keyPath: sortedByNameValue] < player2[keyPath: sortedByNameValue]
                } else {
                    return player1[keyPath: sortedByNameValue] > player2[keyPath: sortedByNameValue]
                }
            }
        } else {
            return { _, _ in true }
        }
    }
    
    func getPlayers() async {
        var myPlayer = Player()
        var lines: [String] = []
        var fillins: Bool = false
        var games: [Player] = []
        lines = GetUrl(url: "\(url)games/team-stats/" + teamsManager.currentTeam.compID + "?team_id=" + teamsManager.currentTeam.teamID)
        total = lines.filter { $0.contains("games/statistics/") }.count
        count = 0
        for i in 0 ..< lines.count {
            if lines[i].contains("Fill ins") { fillins = true }
            if lines[i].contains("\(url)games/statistics/") {
                if lines[i+1].contains(" (fill-in)") {
                    fillins = true
                    lines[i+1] = lines[i+1].replacingOccurrences(of: " (fill-in)", with: "")
                }
                myPlayer.id = UUID()
                myPlayer.statsLink = String(lines[i].split(separator: "\"")[1])
                myPlayer.fillin = fillins
                myPlayer.name = ""
                myPlayer.surname = ""
                myPlayer.captain = false
                (myPlayer.name, myPlayer.surname, myPlayer.captain) = FixName(fullname: lines[i+1].capitalized.trimmingCharacters(in: CharacterSet.letters.inverted))
                myPlayer.numberGames = Int(lines[i+7].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                //            myPlayer.goals = Int(lines[i+11].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                //            myPlayer.greenCards = Int(lines[i+15].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                //            myPlayer.yellowCards = Int(lines[i+19].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                //            myPlayer.redCards = Int(lines[i+23].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                //            myPlayer.goalie = Int(lines[i+27].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                if myPlayer.numberGames > 0 {
                    games = await getPlayer(player: myPlayer, teamsManager: teamsManager)
                    myPlayer.goals = games.reduce(0) { result, myPlayer in result + myPlayer.goals }
                    myPlayer.greenCards = games.reduce(0) { result, myPlayer in result + myPlayer.greenCards }
                    myPlayer.yellowCards = games.reduce(0) { result, myPlayer in result + myPlayer.yellowCards }
                    myPlayer.redCards = games.reduce(0) { result, myPlayer in result + myPlayer.redCards }
                    myPlayer.goalie = games.reduce(0) { result, myPlayer in result + myPlayer.goalie }
                }
                players.append(myPlayer)
                myPlayer = Player()
                fillins = false
                count = count + 1
            }
        }
    }
}

#Preview {
    StatisticsView()
}
