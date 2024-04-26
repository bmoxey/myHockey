//
//  PathState.swift
//  myHockey
//
//  Created by Brett Moxey on 26/4/2024.
//

import Foundation
class PathState: ObservableObject {
    enum Destination: String, Hashable {
        case getComps,getClubs
    }
    @Published var path: [Destination] = []
}
