//
//  FixtureSelectionView.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import SwiftUI

struct FixtureSelectionView: View {
    @Binding var fixtures: [Fixture]
    @Binding var currentFixture: Fixture?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(fixtures, id: \.self) { fixture in
                    VStack {
                        Text(fixture.roundNo)
                            .foregroundStyle(Color.white)
                            .multilineTextAlignment(.center)
                            .fontWeight(.bold)
                        Text(getDay(date: fixture.date))
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
                        self.currentFixture = fixture
                    }
                }
            }
            .frame(height: 115)
            .scrollTargetLayout()
            .padding(.vertical, 0)
        }
        .padding(.vertical, 0)
        .safeAreaPadding(.horizontal, CGFloat(UIScreen.main.bounds.width/3))
        .scrollTargetBehavior(.viewAligned)
        .scrollClipDisabled()
        .scrollPosition(id: $currentFixture, anchor: .center)
        .background(Color.orange)
    }
}

#Preview {
    FixtureSelectionView(fixtures: .constant([]), currentFixture: .constant(Fixture()))
}
