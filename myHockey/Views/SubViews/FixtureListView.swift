//
//  FixtureListView.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import SwiftUI

struct FixtureListView: View {
    @Binding var fixtures: [Fixture]
    @Binding var currentFixture: Fixture?
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            guard let currentFixture, let index = fixtures.firstIndex(of: currentFixture) ,
                                  index > 0 else { return }
                            self.currentFixture = fixtures[index - 1]
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(currentFixture == fixtures.first ? Color.clear : Color.orange)
                            .font(Font.system(size: 17, weight: .semibold))
                    }
                    Spacer()
                    ForEach(fixtures.sorted(by: { $0.date < $1.date }), id: \.self) {fixture in
                        let isCurrent = fixture.roundNo == currentFixture?.roundNo ?? "1"
                        let col = getColor(result: fixture.result)
                        Image(systemName: getSymbol(result: fixture.result))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(isCurrent ? col : Color(.black), isCurrent ? Color(.black) : col)
                            .scaleEffect(isCurrent ? 1.2 : 0.8)
                            .padding(.all, -5)
                            .onTapGesture {
                                withAnimation {
                                    currentFixture = fixture
                                }
                            }
                    }
                    Spacer()
                    Button {
                        withAnimation {
                            guard let currentFixture, let index = fixtures.firstIndex(of: currentFixture),
                                  index < fixtures.count - 1 else { return }
                            self.currentFixture = fixtures[index + 1]
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(currentFixture == fixtures.last ? Color.clear : Color.orange)
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
        .background(Color.white)
    }
}


#Preview {
    FixtureListView(fixtures: .constant([]), currentFixture: .constant(Fixture()))
}
