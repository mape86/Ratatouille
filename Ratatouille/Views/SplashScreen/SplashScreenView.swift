//
//  SplashScreenView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 13/11/2023.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    @State private var rotation = 180.0
    @State private var scale: CGFloat = 0.1
    @State private var opacity = 0.0
    
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            VStack{
                Text("Ratatouille")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
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
                    withAnimation(.easeIn(duration: 1.0)) {
                        rotation = 0.0
                        scale = 1.0
                        opacity = 1.0
                    }
                    withAnimation(.easeIn(duration: 1.0).delay(2.0)) {
                        isActive = true
                    }
                }
                Text("Food App")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

            }
        }
    }
}

#Preview {
    SplashScreenView()
}
