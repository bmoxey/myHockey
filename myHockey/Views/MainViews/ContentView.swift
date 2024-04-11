//
//  ContentView.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import SwiftUI

struct ContentView: View {
    @State var selectedIndex = 0
    @StateObject var teamsManager = TeamsManager()
    var body: some View {
        TabView(selection: $selectedIndex) {
             FixtureView()
                 .onAppear { selectedIndex = 0 }
                 .environmentObject(teamsManager)
                 .tabItem {
                     Image(systemName: "calendar.badge.clock")
                         .symbolRenderingMode(.palette)
                         .foregroundStyle(selectedIndex == 0 ? .white : .gray , selectedIndex == 0 ? .orange : .gray)
                     Text("Fixture") }
                 .tag(0)
                 .toolbarBackground(Color("DarkColor"), for: .tabBar)
                 .toolbarBackground(.visible, for: .tabBar)
             LadderView()
                 .onAppear {
                     selectedIndex = 1
                 }
                 .environmentObject(teamsManager)
                 .tabItem {
                     Image(systemName: "list.number")
                         .symbolRenderingMode(.palette)
                         .foregroundStyle(selectedIndex == 1 ? .white : .gray , selectedIndex == 1 ? .orange : .gray)
                     Text("Ladder")
                 }
                 .tag(1)
                 .toolbarBackground(Color("DarkColor"), for: .tabBar)
                 .toolbarBackground(.visible, for: .tabBar)
             RoundView()
                 .onAppear {
                     selectedIndex = 2
                 }
                 .environmentObject(teamsManager)
                 .tabItem {
                     Image(systemName:  "clock.badge.fill")
                         .symbolRenderingMode(.palette)
                         .foregroundStyle(selectedIndex == 2 ? .white : .gray , selectedIndex == 2 ? .orange : .gray)
                     Text("Round")
                 }
                 .tag(2)
                 .toolbarBackground(Color("DarkColor"), for: .tabBar)
                 .toolbarBackground(.visible, for: .tabBar)
             StatisticsView()
                 .onAppear {
                     selectedIndex = 3
                 }
                 .environmentObject(teamsManager)
                 .tabItem {
                     Image(systemName: "chart.bar.xaxis")
                         .symbolRenderingMode(.palette)
                         .foregroundStyle(selectedIndex == 3 ? .orange : .gray, selectedIndex == 3 ? .white : .gray)
                     Text("Stats")
                 }
                 .tag(3)
                 .toolbarBackground(Color("DarkColor"), for: .tabBar)
                 .toolbarBackground(.visible, for: .tabBar)
             SetTeamView()
                 .onAppear {
                     selectedIndex = 4
                 }
                 .environmentObject(teamsManager)
                 .tabItem {
                     Image(systemName: "person.crop.circle.badge.questionmark.fill")
                         .symbolRenderingMode(.palette)
                         .foregroundStyle(selectedIndex == 4 ? .white : .gray, selectedIndex == 4 ? .orange : .gray)
                     Text("Teams")
                 }
                 .tag(4)
                 .toolbarBackground(Color("DarkColor"), for: .tabBar)
                 .toolbarBackground(.visible, for: .tabBar)
         }
        .accentColor(Color.white)
     }
}

#Preview {
    ContentView()
}
