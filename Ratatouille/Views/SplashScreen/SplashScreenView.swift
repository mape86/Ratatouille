//
//  SplashScreenView.swift
//  Ratatouille

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    @State private var rotation = 270.0
    @State private var scale: CGFloat = 0.01
    @State private var opacity = 0.0
    @State private var textOpacity = 0.0
    @State private var textScale: CGFloat = 0.9
    
    
    var body: some View {
        if isActive {
            CustomTabView()
        } else {
            ZStack {
                Color(.black)
                    .ignoresSafeArea()
                VStack{
                    Text("Ratatouille")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 400)
                .opacity(textOpacity)
                .scaleEffect(textScale)
                .onAppear{
                    withAnimation(.easeIn(duration: 3.0)) {
                        textOpacity = 1.0
                        textScale = 1.0
                    }
                }
                    VStack {
                        Image("Ratatouille")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 400)
                    }
                    .rotationEffect(.degrees(rotation))
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear{
                        withAnimation(.easeIn(duration: 2.6)) {
                            rotation = 0.0
                            scale = 1.2
                            opacity = 1.0
                        }
                    }
                VStack {
                    Text("Food App")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.top, 400)
                .opacity(textOpacity)
                .scaleEffect(textScale)
                .onAppear{
                    withAnimation(.easeIn(duration: 2.5)) {
                        textOpacity = 1.0
                        textScale = 1.0
                    }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
