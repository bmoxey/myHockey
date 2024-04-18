//
//  TeamsManager.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import Foundation
var url = "https://www.hockeyvictoria.org.au/"

class Teams: Identifiable, ObservableObject, Equatable, Encodable, Decodable {
    static func == (lhs: Teams, rhs: Teams) -> Bool {
        lhs.compName == rhs.compName
    }
    let id: UUID
    let compName: String
    let compID: String
    let divName: String
    let divID: String
    let type: String
    let teamName: String
    let teamID: String
    let image: String
    
    init(id: UUID = UUID(), compName: String = "", compID: String = "", divName: String = "", divID: String = "", type: String = "", teamName: String = "", teamID: String = "", image: String = "", isSelected: Bool = false) {
            self.id = id
            self.compName = compName
            self.compID = compID
            self.divName = divName
            self.divID = divID
            self.type = type
            self.teamName = teamName
            self.teamID = teamID
            self.image = image
        }
}

class TeamsManager: ObservableObject {
    var change: Bool = false
    @Published var currentTeam: Teams = Teams()
    @Published var myTeams: [Teams] = []

    init() {
        loadTeams()
    }

    func saveTeams() {
        do {
            var teamsToSave = myTeams
            teamsToSave.append(currentTeam)
            
            let data = try JSONEncoder().encode(teamsToSave)
            UserDefaults.standard.set(data, forKey: "currentTeams")
        } catch {
            print("Error encoding teams: \(error)")
        }
    }

    func loadTeams() {
        if let data = UserDefaults.standard.data(forKey: "currentTeams") {
            do {
                let decodedTeams = try JSONDecoder().decode([Teams].self, from: data)
                
                if let lastTeam = decodedTeams.last {
                    currentTeam = lastTeam
                }
                
                myTeams = Array(decodedTeams.dropLast())
            } catch {
                print("Error decoding teams: \(error)")
            }
        }
    }
}

struct TeamSummary: Identifiable {
    let id = UUID()
    let compName: String
    var numberOfTeams: Int
    var isSelected: Bool
}


class TeamsSum: ObservableObject {
    var keywordsToSelect: [String] = ["Senior", "Junior", "Midweek"]

    var teamSummary: ([Teams]) -> [TeamSummary] {
        { (teams: [Teams]) -> [TeamSummary] in
            let summaryDictionary = teams.reduce(into: [String: Int]()) { result, team in
                result[team.compName, default: 0] += 1
            }
            return summaryDictionary.map { key, value in
                let isSelected = self.shouldSelectTeam(compName: key)
                return TeamSummary(compName: key, numberOfTeams: value, isSelected: isSelected)
            }
        }
    }

    private func shouldSelectTeam(compName: String) -> Bool {
        for keyword in keywordsToSelect {
            if compName.contains(keyword) {
                return true
            }
        }
        return false
    }
}
