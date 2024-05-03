//
//  DetailLadderHeaderView.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import SwiftUI

struct DetailLadderHeaderView: View {
    @Binding var mode: String
    var body: some View {
         HStack {
             Text("Team")
                 .font(.footnote)
                 .foregroundStyle(Color.white)
                 .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
             if mode == "Detailed" {
                 Text("GF")
                     .font(.footnote)
                     .foregroundStyle(Color.white)
                     .frame(width: 40, alignment: .trailing)
                 Text("GA")
                     .font(.footnote)
                     .foregroundStyle(Color.white)
                     .frame(width: 40, alignment: .trailing)
             }
             Text("GD")
                 .font(.footnote)
                 .foregroundStyle(Color.white)
                 .frame(width: 40, alignment: .trailing)
             Text("Pts")
                 .font(.footnote)
                 .foregroundStyle(Color.white)
                 .frame(width: 40, alignment: .trailing)
             Text("WR")
                 .font(.footnote)
                 .foregroundStyle(Color.white)
                 .frame(width: 60, alignment: .center)
         }
     }
 }

#Preview {
    DetailLadderHeaderView(mode: .constant("Detail"))
}
