//
//  RoundListView.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import SwiftUI

struct RoundListView: View {
    @Binding var rounds: [Rounds]
    @Binding var currentRound: Rounds?
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            guard let currentRound, let index = rounds.firstIndex(of: currentRound) ,
                                  index > 0 else { return }
                            self.currentRound = rounds[index - 1]
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(currentRound == rounds.first ? Color.clear: Color("AccentColor"))
                            .font(Font.system(size: 17, weight: .semibold))
                    }
                    Spacer()
                    ForEach(rounds, id:\.self) {round in
                        let isCurrent = round.roundNo == currentRound?.roundNo ?? "1"
                        Image(systemName: getSymbol(result: round.result, roundNo: round.roundNo, isCurrent: isCurrent))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(isCurrent ? Color(UIColor.lightGray) : Color(.black), isCurrent ? Color(.black) : Color(UIColor.lightGray))
                            .scaleEffect(isCurrent ? 1.2 : 0.8)
                            .padding(.all, -5)
                            .onTapGesture {
                                withAnimation {
                                    currentRound = round
                                }
                            }
                    }
                    Spacer()
                    Button {
                        withAnimation {
                            guard let currentRound, let index = rounds.firstIndex(of: currentRound),
                                  index < rounds.count - 1 else { return }
                            self.currentRound = rounds[index + 1]
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(currentRound == rounds.last ? Color.clear :  Color("AccentColor"))
                            .font(Font.system(size: 17, weight: .semibold))
                    }
                    Spacer()
                }
                .frame(minWidth: geometry.size.width)
                .frame(height: 25)
            }
            .padding(.vertical, 0)
        }
        .frame(height: 25)
        .padding(.top, -8)
    }
}

#Preview {
    RoundListView(rounds: .constant([]), currentRound: .constant(Rounds()))
}

