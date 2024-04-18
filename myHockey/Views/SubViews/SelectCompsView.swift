//
//  SelectCompsView.swift
//  myHockey
//
//  Created by Brett Moxey on 18/4/2024.
//

import SwiftUI

struct SelectCompsView: View {
    @Binding var comps: [Teams]
    @Binding var compList: [TeamSummary]
    @Binding var searching: Bool
    var body: some View {
        HStack {
            Text("Competitions to search")
                .foregroundStyle(Color.white)
            Spacer()
            Text("Grades")
                .foregroundStyle(Color.white)
        }
        .listRowBackground(Color("DarkColor"))
        ForEach(compList.indices, id: \.self) { index in
            let summary = compList[index]
            HStack {
                Image(systemName: summary.isSelected ? "checkmark.circle.fill" : "x.circle")
                    .foregroundStyle(Color(summary.isSelected ? .green : .red))
                    .symbolEffect(.pulse)
                Text(summary.compName)
                    .foregroundStyle(Color("DarkColor"))
                Spacer()
                Text("\(summary.numberOfTeams)")
                    .foregroundStyle(Color("DarkColor"))
            }
            .listRowBackground(Color.white)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                    compList[index].isSelected.toggle()
                }
            }
        }
        Section {
            Button {
                searching = true
            } label: {
                HStack {
                    Text("Search HV website for clubs")
                        .foregroundStyle(Color.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.orange)
                }
            }
            .listRowBackground(Color("DarkColor"))
            
        }
    }
}

#Preview {
    SelectCompsView(comps: .constant([]), compList: .constant([]), searching: .constant(true))
}
