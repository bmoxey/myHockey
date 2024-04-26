//
//  CustomAlert.swift
//  myHockey
//
//  Created by Brett Moxey on 24/4/2024.
//

import SwiftUI

extension View {
    func customConfirmDialog<A: View>(isPresented: Binding<Bool>, @ViewBuilder actions: @escaping () -> A) -> some View {
        return self.modifier(MyCustomModifier(isPresented: isPresented, actions: actions))
    }
}

struct MyCustomModifier<A>: ViewModifier where A: View {
    
    @Binding var isPresented: Bool
    @ViewBuilder let actions: () -> A
    
    func body(content: Content) -> some View {
        
        ZStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ZStack(alignment: .top) {
                if isPresented {
                    Color.primary.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isPresented = false
                        }
                        .transition(.opacity)
                }
                
                if isPresented {
                    VStack {
                        GroupBox {
                            HStack {
                                Spacer()
                                Text("Select current team")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.orange)
                                Spacer()
                            }
                            actions()
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .groupBoxStyle(CustomGroupBoxStyle())
                        GroupBox {
                            Button {
                                isPresented = false
                            } label: {
                                Text("Cancel")
                                    .foregroundStyle(Color.orange)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                        .groupBoxStyle(CustomGroupBoxStyle())
                    }
                    .padding(.all, 8)
                    .transition(.move(edge: .top))
                }
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}



