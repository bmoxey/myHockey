//
//  RoundSummaryView.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import SwiftUI

struct RoundSummaryView: View {
    @Binding var round: Round
     var body: some View {
         Section() {
             HStack {
                 Spacer()
                 Text("\(round.roundNo)")
                     .foregroundStyle(Color.white)
                 Spacer()
             }
             .listRowBackground(Color("DarkColor"))
             VStack {
                 HStack {
                     Text(round.homeTeam)
                         .fontWeight(round.homeTeam == round.myTeam ? .bold : .regular)
                         .multilineTextAlignment(.center)
                     Spacer()
                     Text("VS")
                     Spacer()
                     Text(round.awayTeam)
                         .fontWeight(round.awayTeam == round.myTeam ? .bold : .regular)
                         .multilineTextAlignment(.center)
                 }
                 HStack {
                     Image(GetImage(teamName: round.homeTeam))
                         .resizable()
                         .frame(width: 75, height: 75)
                     Text("\(round.homeGoals)")
                         .fontWeight(round.homeTeam == round.myTeam ? .bold : .regular)
                         .font(.largeTitle)
                     Spacer()
                     Text(" \(round.result) ")
                         .fontWeight(.bold)
                         .background(getColor(result: round.result))
                         .font(.title3)
                     Spacer()
                     Text("\(round.awayGoals)")
                         .fontWeight(round.awayTeam == round.myTeam ? .bold : .regular)
                         .font(.largeTitle)
                     Image(GetImage(teamName: round.awayTeam))
                         .resizable()
                         .frame(width: 75, height: 75)
                 }
                 HStack {
                     HStack {
                         if Int(round.homeGoals) ?? 0 > 0 {
                             Text(String(repeating: "●", count: Int(round.homeGoals) ?? 0))
                                 .foregroundStyle(round.homeTeam == round.myTeam ? Color.green : Color.red)
                                 .font(.system(size:20))
                                 .padding(.horizontal, 0)
                                 .multilineTextAlignment(.leading)
                                 .lineLimit(nil)
                         }
                         Spacer()
                     }
                     .frame(width: 100)
                     Spacer()
                     Text("@ \(round.field)")
                     Spacer()
                     HStack {
                         Spacer()
                         if Int(round.awayGoals) ?? 0 > 0 {
                             Text(String(repeating: "●", count: Int(round.awayGoals) ?? 0 ))
                                 .foregroundStyle(round.awayTeam == round.myTeam ? Color.green : Color.red)
                                 .font(.system(size:20))
                                 .padding(.horizontal, 0)
                                 .multilineTextAlignment(.trailing)
                                 .lineLimit(nil)
                             
                         }
                     }
                     .frame(width: 100)
                 }
             }
             .foregroundStyle(Color("DarkColor"))
             .listRowBackground(getColor(result: round.result).brightness(0.60))
         }
     }
 }

 #Preview {
     RoundSummaryView(round: .constant(Round()))
 }
