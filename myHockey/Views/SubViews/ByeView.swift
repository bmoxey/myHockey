//
//  ByeView.swift
//  myHockey
//
//  Created by Brett Moxey on 17/4/2024.
//

import SwiftUI

struct ByeView: View {
    let myTeam: String
    let team: String

    var body: some View {
        HStack {
            HStack {
                Spacer()
                VStack {
                    Image(GetImage(teamName: team))
                        .resizable()
                        .frame(width: 75, height: 75)
                    Text("\(team)")
                        .foregroundStyle(Color("DarkColor"))
                        .fontWeight(team == myTeam ? .bold : .regular)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
                Spacer()
            }
            HStack {
                Text("has a BYE")
                    .foregroundStyle(Color("DarkColor"))
            }
            HStack {
                Spacer()
                Text("\(team)")
                    .foregroundStyle(Color.clear)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                Spacer()
            }
        }
    }
}


#Preview {
    ByeView(myTeam: "MHSOB", team: "MHSOB")
}
