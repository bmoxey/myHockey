//
//  Fixtures.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import Foundation
struct FixtureFile: Codable, Identifiable {
    var id: UUID
    var roundNo: String
    var roundURL: String
    var compName: String
    var compID: String
    var divName: String
    var divID: String
    
    init() {
        self.id = UUID()
        self.roundNo = ""
        self.roundURL = ""
        self.compName = ""
        self.compID = ""
        self.divName = ""
        self.divID = ""
    }
}

struct Fixture: Codable, Identifiable, Hashable {
    var id: UUID
    var roundNo: String
    var date: Date
    var field: String
    var venue: String
    var myTeam: String
    var opponent: String
    var result: String
    var status: String
    var gameID: String
    
    init() {
        self.id = UUID()
        self.roundNo = ""
        self.date = Date()
        self.field = ""
        self.venue = ""
        self.myTeam = ""
        self.opponent = ""
        self.result = ""
        self.status = ""
        self.gameID = ""
    }
}
