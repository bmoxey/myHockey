//
//  ByeHeaderView.swift
//  myHockey
//
//  Created by Brett Moxey on 17/4/2024.
//

import SwiftUI

struct ByeHeaderView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("No game this round")
                .frame(alignment: .center)
                .foregroundStyle(Color.black)
            Spacer()
        }
        .listRowBackground(getColor(result: "BYE"))
    }
}

#Preview {
    ByeHeaderView()
}
