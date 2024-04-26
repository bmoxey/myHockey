//
//  PlayersView.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import SwiftUI

struct PlayersView: View {
    @State var searchTeam: String
    @Binding var myRound: Round
    @Binding var players: [Player]

    var body: some View {
        if !players.isEmpty {
            Section(header: Text("Players").foregroundStyle(Color.white)) {
                Picker("Team:", selection: $searchTeam) {
                    Text(myRound.homeTeam)
                        .tag(ShortTeamName(fullName: myRound.homeTeam))
                    Text(myRound.awayTeam)
                        .tag(ShortTeamName(fullName: myRound.awayTeam))
                }
                .onAppear {
                    UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.orange)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color("DarkColor"))], for: .selected)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.orange)], for: .normal)
                }
                .pickerStyle(SegmentedPickerStyle())
                .listRowBackground(Color("DarkColor"))
                ForEach(players.sorted(by: { $0.surname < $1.surname }), id: \.id) {player in
                    if player.team == searchTeam {
                        PlayerView(player: player)
                    }
                }
            }
            .onChange(of: myRound) {
                searchTeam = myRound.myTeam
            }
        }
    }
}

#Preview {
    PlayersView(searchTeam: "", myRound: .constant(Round()), players: .constant([]))
}
