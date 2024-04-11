//
//  CenterTextView.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import SwiftUI

struct CenterTextView: View {
    @State var text: String
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text(text)
                    .foregroundStyle(Color.white)
                    .font(.largeTitle)
                Spacer()
            }
            Spacer()
        }
        .background(Color("DarkColor").brightness(0.2))

    }
}

#Preview {
    CenterTextView(text: "Loading...")
}
