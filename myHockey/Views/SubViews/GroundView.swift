//
//  GroundView.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import SwiftUI

struct GroundView: View {
    @Binding var fixture: Fixture?
    @Binding var address: String
    var body: some View {
        Section() {
            Text(fixture?.venue ?? "")
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color("DarkColor"))
            VStack {
                HStack {
                    Image(systemName: "sportscourt.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundStyle(Color("DarkColor"))
                    Text(fixture?.field ?? "")
                        .foregroundStyle(Color("DarkColor"))
                        .font(.largeTitle)
                }
                Text(address)
                    .foregroundStyle(Color("DarkColor"))
                    .frame(maxWidth: .infinity, alignment: .center)
                Button {
                    openGoogleMaps(with: "\(fixture?.venue ?? ""), \(address) , Victoria, Australia", label: "\(fixture?.venue ?? "")")
                } label: {
                    HStack {
                        Text("Open in Google Maps")
                            .foregroundColor(Color.blue)
                        Image(systemName: "chevron.right")
                            .font(Font.system(size: 17, weight: .semibold))
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("AccentColor"))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .listRowBackground(Color.white)
        }
    }
    func openGoogleMaps(with address: String, label: String) {
        if let url = URL(string: "comgooglemaps://?q=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&label=\(label.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let safariURL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")
                UIApplication.shared.open(safariURL!, options: [:], completionHandler: nil)
            }
        }
    }
}

#Preview {
    GroundView(fixture: .constant(Fixture()), address: .constant("ccc"))
}
