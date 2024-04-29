//
//  DetailLadderView.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import SwiftUI

struct DetailLadderView: View {
    @Binding var mode: String
    let myTeam: String
    let item: LadderItem
    let maxScore: Int
    @State var selectedItem: LadderItem = LadderItem()
    var body: some View {
        HStack {
            Image(systemName: item.teamName == myTeam ? "\(item.pos).circle.fill" : "\(item.pos).circle")
                .foregroundStyle(Color("DarkColor"))
            Image(GetImage(teamName: item.teamName))
                .resizable()
                .frame(width: 45, height: 45)
                .padding(.vertical, -4)
            if mode == "Detailed" {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("\(item.scoreFor)")
                            .frame(width: 40, alignment: .trailing)
                            .fontWeight(item.teamName == myTeam ? .bold : .regular)
                            .foregroundStyle(Color("DarkColor"))
                        Text("\(item.scoreAgainst)")
                            .frame(width: 40, alignment: .trailing)
                            .fontWeight(item.teamName == myTeam ? .bold : .regular)
                            .foregroundStyle(Color("DarkColor"))
                        Text("\(item.diff)")
                            .frame(width: 40, alignment: .trailing)
                            .fontWeight(item.teamName == myTeam ? .bold : .regular)
                            .foregroundStyle(Color("DarkColor"))
                        Text("\(item.points)")
                            .frame(width: 40, alignment: .trailing)
                            .fontWeight(item.teamName == myTeam ? .bold : .regular)
                            .foregroundStyle(Color("DarkColor"))
                        Text("\(item.winRatio)")
                            .frame(width: 60, alignment: .trailing)
                            .fontWeight(item.teamName == myTeam ? .bold : .regular)
                            .foregroundStyle(Color("DarkColor"))
                    }
                    GeometryReader { geometry in
                        HStack(spacing: 0){
                            let maxResultWidth = Int(geometry.size.width - 20)
                            Spacer()
                            if item.wins > 0 {
                                Rectangle()
                                    .fill(.green)
                                    .frame(width: CGFloat(item.wins * maxResultWidth / (item.played + item.byes)), height: 10)
                                    .padding(.all, 0)
                            }
                            if item.draws > 0 {
                                Rectangle()
                                    .fill(.yellow)
                                    .frame(width: CGFloat(item.draws * maxResultWidth / (item.played + item.byes)), height: 10)
                                    .padding(.all, 0)
                            }
                            if item.losses > 0 {
                                Rectangle()
                                    .fill(.red)
                                    .frame(width: CGFloat(item.losses * maxResultWidth / (item.played + item.byes)), height: 10)
                                    .padding(.all, 0)
                            }
                            if item.byes > 0 {
                                Rectangle()
                                    .fill(.cyan)
                                    .frame(width: CGFloat(item.byes * maxResultWidth / (item.played + item.byes)), height: 10)
                                    .padding(.all, 0)
                            }
                        }
                    }
                }
            } else {
                Text(item.teamName)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .fontWeight(item.teamName == myTeam ? .bold : .regular)
                    .foregroundStyle(Color("DarkColor"))
                Text("\(item.diff)")
                    .frame(width: 40, alignment: .trailing)
                    .fontWeight(item.teamName == myTeam ? .bold : .regular)
                    .foregroundStyle(Color("DarkColor"))
                Text("\(item.points)")
                    .frame(width: 40, alignment: .trailing)
                    .fontWeight(item.teamName == myTeam ? .bold : .regular)
                    .foregroundStyle(Color("DarkColor"))
                Text("\(item.winRatio)")
                    .frame(width: 60, alignment: .trailing)
                    .fontWeight(item.teamName == myTeam ? .bold : .regular)
                    .foregroundStyle(Color("DarkColor"))

            }
        }
//        .onTapGesture {
//            if selectedItem == item {
//                selectedItem = LadderItem()
//            } else {
//                selectedItem = item
//            }
//        }
//        if selectedItem == item {
//            ItemDetailView(item: item, maxScore: maxScore)
//        }
    }
    
}


#Preview {
    DetailLadderView(mode: .constant("Detailed"), myTeam: "MHSOB", item: LadderItem(), maxScore: 100)
}
