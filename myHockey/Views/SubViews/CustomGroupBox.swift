//
//  CustomGroupBox.swift
//  myHockey
//
//  Created by Brett Moxey on 24/4/2024.
//

import SwiftUI

struct CustomGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .foregroundColor(Color.orange)
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.bottom, 4)
            configuration.content
        }
        .padding(.vertical)
        .background(Color("DarkColor"))
        .cornerRadius(16)
    }
}
