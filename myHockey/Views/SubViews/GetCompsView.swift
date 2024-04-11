//
//  GetCompsView.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import SwiftUI

struct GetCompsView: View {
    @Binding var comps: [Teams]
    @Binding var myComp: Teams
    @Binding var searchComp: String
    @State private var searchType = "ALL"
    var body: some View {
        let uniqueCompArray = comps.reduce(into: Set<String>()) { result, competition in result.insert(competition.compName)}.sorted()
        let uniqueTypeArray = comps.reduce(into: Set<String>()) { result, competition in result.insert(competition.type)}.union(["ALL"]).sorted()
        Section(header: Text("Add team from competition...").foregroundStyle(Color.white)) {
            HStack {
                Image("HVLogo")
                    .resizable()
                    .frame(width: 35, height: 35)
                Picker("", selection: $searchComp) {
                    ForEach(uniqueCompArray, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .tint(.orange)
            }
            .listRowBackground(Color("DarkColor"))
            Picker("Type", selection: $searchType) {
                ForEach(uniqueTypeArray, id: \.self) {type in
                    Text(type)
                        .foregroundColor(Color.blue)
                }
            }
            .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("DarkColor"))
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color("DarkColor"))], for: .normal)
            }
            .pickerStyle(SegmentedPickerStyle())
            .listRowBackground(Color("AccentColor"))
            ForEach(comps) { comp in
                if comp.compName == searchComp {
                    if comp.type == searchType || searchType == "ALL" {
                        HStack {
                            Text(comp.type)
                            Text(comp.divName)
                                .foregroundStyle(Color("DarkColor"))
                                .onTapGesture { myComp = comp }
                        }
                        .listRowBackground(Color.white.opacity(0.8))
                    }
                }
            }
        }
    }
}

#Preview {
    GetCompsView(comps: .constant([]), myComp: .constant(Teams()), searchComp: .constant(""))
}
