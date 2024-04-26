//
//  DetailLadderHeaderView.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import SwiftUI

struct DetailLadderHeaderView: View {
    var body: some View {
         HStack {
             Text("Pos")
                 .font(.footnote)
                 .foregroundStyle(Color.white)
                 .frame(width: 35, alignment: .leading)
             Text("Team")
                 .font(.footnote)
                 .foregroundStyle(Color.white)
                 .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
             Text("GD")
                 .font(.footnote)
                 .foregroundStyle(Color.white)
                 .frame(width: 40, alignment: .trailing)
             Text("Pts")
                 .font(.footnote)
                 .foregroundStyle(Color.white)
                 .frame(width: 40, alignment: .trailing)
             Image(systemName: "chevron.right")
                 .font(Font.system(size: 17, weight: .semibold))
                 .foregroundColor(Color.clear)
         }
     }
 }

#Preview {
    DetailLadderHeaderView()
}
