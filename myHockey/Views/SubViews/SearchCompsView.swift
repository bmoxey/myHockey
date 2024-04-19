//
//  SearchCompsView.swift
//  myHockey
//
//  Created by Brett Moxey on 18/4/2024.
//

import SwiftUI

struct SearchCompsView: View {
    @Binding var teams: [Teams]
    var comps: [Teams]
    var compList: [TeamSummary]
    @Binding var stillLoading: Bool
    @State private var searchComp: String = ""
    @State private var searchDiv: String = ""
    @State private var divsFound: Int = 0
    @State private var totalDivs: Int = 0
    @State private var teamsFound: Int = 0
    var body: some View {
        VStack {
            Image("HVText")
                .resizable()
                .frame(width: 200, height: 73)
                .padding(.top, 20)
            Spacer()
            Image("HVPlayer")
                .resizable()
                .frame(width: 250, height: 293)
            Spacer()
            Text(searchDiv)
                .foregroundStyle(Color.white)
            HStack {
                Text("Teams found: ")
                    .foregroundStyle(Color.white)
                Text("\(teamsFound)")
                    .foregroundStyle(Color.orange)
            }
            ProgressView("Searching website for teams...",value: Double(divsFound), total: Double(totalDivs))
                .foregroundStyle(Color.white)
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(Color("DarkColor"))
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .onAppear() {
            Task {
                await GetTeams()
            }
        }
    }
    func GetTeams() async {
        stillLoading = true
        var lines: [String] = []
        let selectedComps = compList.filter({ $0.isSelected })
        totalDivs = selectedComps.reduce(0) { $0 + $1.numberOfTeams }
        let filteredComps = comps.filter { comp in
            selectedComps.contains { $0.compName == comp.compName }
        }
        for selectedComp in filteredComps {
            searchComp = selectedComp.compName
            searchDiv = selectedComp.divName
            divsFound += 1
            lines = GetUrl(url: "\(url)pointscore/" + selectedComp.compID + "/" + selectedComp.divID)
            for i in 0 ..< lines.count {
                if lines[i].contains("\(url)games/team/") {
                    teamsFound += 1
                    let teamID = String(String(lines[i]).split(separator: "/")[5]).trimmingCharacters(in: .punctuationCharacters)
                    let compID = String(String(lines[i]).split(separator: "/")[4])
                    let teamName = ShortTeamName(fullName: lines[i+1])
                    let image = GetImage(teamName: teamName)
                    teams.append(Teams(compName: selectedComp.compName, compID: compID, divName: selectedComp.divName, divID: selectedComp.divID, type: selectedComp.type, teamName: teamName, teamID: teamID, image: image))
                }
            }
        }
        stillLoading = false
    }
}

#Preview {
    SearchCompsView(teams: .constant([]), comps: [], compList: [], stillLoading: .constant(true))
}
