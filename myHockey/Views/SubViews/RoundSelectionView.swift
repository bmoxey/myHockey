//
//  RoundSelectionView.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import SwiftUI

struct RoundSelectionView: View {
    @Binding var rounds: [Rounds]
    @Binding var currentRound: Rounds?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(rounds, id: \.self) { round in
                    VStack {
                        Text(round.roundNo)
                            .foregroundStyle(Color.white)
                            .multilineTextAlignment(.center)
                            .fontWeight(.bold)
                        Text(round.textdate)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .font(.footnote)
                    }
                    .frame(width: 150, height: 80)
                    .background(Color("DarkColor"))
                    .cornerRadius(15.0)
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    .shadow(radius: 5, y: 5)
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.75)
                            .scaleEffect(phase.isIdentity ? 1 : 0.5)
//                                    .blur(radius: phase.isIdentity ? 0 : 0.75)
                            .saturation(phase.isIdentity ? 1 : 0.75)
                            .rotation3DEffect(.init(radians: phase.value*1.57), axis: (0,0,1))
                    }
                    .onTapGesture {
                        self.currentRound = round
                    }
                }
            }
            .frame(height: 120)
            .scrollTargetLayout()
            .padding(.vertical, 0)
        }
        .padding(.vertical, 0)
        .background(Color.orange)
        .safeAreaPadding(.horizontal, CGFloat(UIScreen.main.bounds.width/3))
        .scrollTargetBehavior(.viewAligned)
        .scrollClipDisabled()
        .scrollPosition(id: $currentRound, anchor: .center)
    }
}

#Preview {
    RoundSelectionView(rounds: .constant([]), currentRound: .constant(Rounds()))
}
