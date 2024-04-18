//
//  BYEFixtureView.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import SwiftUI

struct BYEFixtureView: View {
    @Binding var fixture: Fixture?
    var body: some View {
        Section() {
            HStack {
                Spacer()
                Text("No game this week")
                    .frame(alignment: .center)
                    .foregroundStyle(Color.white)
                Spacer()
            }
            .listRowBackground(Color("DarkColor"))
            HStack {
                Image(GetImage(teamName: fixture?.myTeam ?? "HVLogo"))
                    .resizable()
                    .frame(width: 75, height: 75)
                Spacer()
                VStack {
                    Text(fixture?.myTeam ?? "")
                        .multilineTextAlignment(.center)
                    Text("")
                    Text("has a BYE")
                }
                Spacer()
                DateBoxView(date: fixture?.date ?? Date(), fullDate: false)
            }
            .listRowBackground(getColor(result: fixture?.result ?? "Draw").brightness(0.9))
            .foregroundStyle(Color("DarkColor"))
        }
    }
}


#Preview {
    BYEFixtureView(fixture: .constant(Fixture()))
}
