//
//  UpcomingFixtureView.swift
//  myHockey
//
//  Created by Brett Moxey on 10/4/2024.
//

import SwiftUI

struct UpcomingFixtureView: View {
    @Binding var fixture: Fixture?
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer? = nil
    var body: some View {
        Section() {
            HStack {
                Spacer()
                if timeRemaining > 0 {
                    Text("\(countdownString())")
                        .frame(alignment: .center)
                        .foregroundStyle(Color.white)
                } else {
                    Text("Game has started")
                        .frame(alignment: .center)
                        .foregroundStyle(Color.white)
                }
                Spacer()
            }
            .listRowBackground(getColor(myDate: fixture?.date ?? Date()))
            .onAppear {
                timeRemaining = fixture?.date.timeIntervalSinceNow ?? 0
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    timeRemaining = fixture?.date.timeIntervalSinceNow ?? 0
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    private func countdownString() -> String {
        let days = Int(timeRemaining) / (60 * 60 * 24)
        let hours = Int(timeRemaining) % (60 * 60 * 24) / 3600
        let minutes = Int(timeRemaining) % 3600 / 60
        let seconds = Int(timeRemaining) % 60
        if days > 0 { return String(format: "Game starts in %d days, %d hours", days, hours) }
        if hours > 0 { return String(format: "Game starts in %d hours, %d minutes", hours, minutes)}
        return String(format: "Game starts in %d mins, %d secs", minutes, seconds)
    }
    
    private func getColor(myDate: Date) -> Color {
        let currentDate = Date()
        let daysDifference = Calendar.current.dateComponents([.day], from: currentDate, to: myDate).day ?? 0
        
        let hue = CGFloat((daysDifference % 255) * 360 / 255) / 360.0 // Normalize to [0, 1]
                
        let saturation: CGFloat = 1.0
        let lightness: CGFloat = 0.5
        
        let color = Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(lightness))
                
        return color
    }
}

#Preview {
    UpcomingFixtureView(fixture: .constant(Fixture()))
}
