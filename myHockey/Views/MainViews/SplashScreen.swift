//
//  SplashScreen.swift
//  myHockey
//
//  Created by Brett Moxey on 2/5/2024.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
//    @State private var size = 0.8
//    @State private var opacity = 0.5
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color("DarkColor")
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        Spacer()
                        Image("myHockey")
                            .resizable()
                            .frame(width: 200, height: 36)
                            .padding()
                        Spacer()
                        Image("HVPlayer")
                            .resizable()
                            .frame(width: 300, height: 354.4)
//                            .opacity(opacity)
//                            .scaleEffect(size)
                        Spacer()
                        Text("by Brett Moxey")
                            .font(.title)
                            .foregroundStyle(Color.white)
                        Spacer()
                    }
                }
//                .onAppear {
//                    withAnimation(.easeIn(duration: 1.2)) {
//                        self.size = 1.0
//                        self.opacity = 1.0
//                    }
//                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
