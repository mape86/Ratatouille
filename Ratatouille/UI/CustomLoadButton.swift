//
//  CustomLoadButton.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 16/11/2023.
//

import SwiftUI

struct CustomLoadButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            Text(title)
                .padding()
                .foregroundColor(.white)
                .font(.headline.bold())
                .background(LinearGradient(colors: [.blue, .purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(15)
        }
    }
}

#Preview {
    CustomLoadButton(title: "") {
        print("Button tapped")
    }
}
