//
//  GameResultView.swift
//  myHockey
//
//  Created by Brett Moxey on 17/4/2024.
//

import SwiftUI

struct GameResultView: View {
    var game: Round
    var body: some View {
        HStack {
            Spacer()
            Text("\(game.result) for \(game.myTeam)")
                .frame(alignment: .center)
                .foregroundStyle(Color.black)
            Spacer()
        }
        .listRowBackground(getColor(result: game.result))
    }
}

#Preview {
    GameResultView(game: Round())
}
