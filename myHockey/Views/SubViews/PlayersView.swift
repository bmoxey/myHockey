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
        Section() {
            HStack {
                Spacer()
                Text("Players")
                Spacer()
            }
            .listRowBackground(Color("DarkColor"))
            .foregroundStyle(Color.white)
            Picker("Team:", selection: $searchTeam) {
                Text(myRound.homeTeam)
                    .tag(ShortTeamName(fullName: myRound.homeTeam))
                Text(myRound.awayTeam)
                    .tag(ShortTeamName(fullName: myRound.awayTeam))
            }
            .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("DarkColor"))
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color("DarkColor"))], for: .normal)
            }
            .pickerStyle(SegmentedPickerStyle())
            .listRowBackground(Color("AccentColor"))
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

#Preview {
    PlayersView(searchTeam: "", myRound: .constant(Round()), players: .constant([]))
}
