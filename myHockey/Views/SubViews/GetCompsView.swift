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
    @State private var searchComp = "ALL"
    @State private var searchType = "ALL"
    var body: some View {
        let uniqueCompArray = comps.reduce(into: Set<String>()) { result, competition in result.insert(competition.compName)}.union(["ALL"]).sorted()
        let uniqueTypeArray = comps.reduce(into: Set<String>()) { result, competition in result.insert(competition.type)}.union(["ALL"]).sorted()
        HStack {
            Text("Select comp:")
            Picker("", selection: $searchComp) {
                ForEach(uniqueCompArray, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.menu)
            .tint(.orange)
        }
        .listRowBackground(Color("DarkColor"))
        VStack {
            Text("Filter by gender and age group")
                .foregroundStyle(Color("DarkColor"))
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
        }
        .listRowBackground(Color("AccentColor"))
        ForEach(comps) { comp in
            if comp.compName == searchComp || searchComp == "ALL" {
                if comp.type == searchType || searchType == "ALL" {
                    HStack {
                        Text(comp.type)
                        Text(comp.divName)
                            .foregroundStyle(Color("DarkColor"))
                            .onTapGesture { myComp = comp }
                    }
                    .listRowBackground(Color.white)
                }
            }
        }
    }
}

#Preview {
    GetCompsView(comps: .constant([]), myComp: .constant(Teams()))
}
