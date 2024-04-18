//
//  CompsView.swift
//  myHockey
//
//  Created by Brett Moxey on 18/4/2024.
//

import SwiftUI

struct CompsView: View {
    @EnvironmentObject private var teamsManager: TeamsManager    
    @Environment(\.presentationMode) var presentationMode
    @State private var comps: [Teams] = []
    @State private var selectedTypeFilter = "All"
    @State private var selectedCompFilter = "All"
    @State private var compfilterOptions: [String] = []
    @State private var typeFilterOptions: [String] = []
    
    var filteredComps: [Teams] {
        var filteredComps = comps
        if selectedCompFilter != "All" { filteredComps = filteredComps.filter { $0.compName == selectedCompFilter }}
        if selectedTypeFilter != "All" { filteredComps = filteredComps.filter { $0.type == selectedTypeFilter }}
        return filteredComps
    }
    
    var body: some View {
        List {
            if !comps.isEmpty {
                VStack {
                    Picker(selection: $selectedCompFilter, label: Text("Filter:")) {
                        ForEach(compfilterOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedCompFilter) {
                        updateTypeFilterOptions()
                    }
                    Picker(selection: $selectedTypeFilter, label: Text("Type:")) {
                        ForEach(typeFilterOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedTypeFilter) {
                        updateCompFilterOptions()
                    }
                }
                .listRowBackground(Color("DarkColor"))
                
                ForEach(filteredComps) { comp in
                    NavigationLink {
                        GetTeamCompsView(myComp: comp)
                            .environmentObject(teamsManager)
                    } label: {
                        HStack {
                            Text(comp.type)
                            Text(comp.divName)
                                .foregroundStyle(Color("DarkColor"))
                        }
                    }
                    .listRowBackground(Color.white)
                    .foregroundStyle(.white, .orange)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("DarkColor").brightness(0.2))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Select Your Competition")
                    .foregroundStyle(Color.white)
                    .fontWeight(.semibold)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image("HVLogo")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
        }
        .toolbarBackground(Color("DarkColor"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .task {
            if teamsManager.change {
                teamsManager.change = false
                teamsManager.saveTeams()
                self.presentationMode.wrappedValue.dismiss()
            }
            comps = await getComps()
            compfilterOptions = Array(Set(comps.map { $0.compName }))
            compfilterOptions.insert("All", at: 0)
            compfilterOptions.sort()
            typeFilterOptions = Array(Set(comps.map { $0.type }))
            typeFilterOptions.insert("All", at: 0)
            typeFilterOptions.sort()
        }
    }
    
    private func updateTypeFilterOptions() {
        if selectedCompFilter == "All" {
            typeFilterOptions = Array(Set(comps.map { $0.type }))
        } else {
            typeFilterOptions = Array(Set(comps.filter { $0.compName == selectedCompFilter }.map { $0.type }))
        }
        typeFilterOptions.insert("All", at: 0)
        typeFilterOptions.sort()
    }
    
    private func updateCompFilterOptions() {
        if selectedTypeFilter == "All" {
            compfilterOptions = Array(Set(comps.map { $0.compName }))
        } else {
            compfilterOptions = Array(Set(comps.filter { $0.type == selectedTypeFilter }.map { $0.compName }))
        }
        compfilterOptions.insert("All", at: 0)
        compfilterOptions.sort()
    }
}


#Preview {
    CompsView()
}
