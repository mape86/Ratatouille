//
//  CustomLoadButton.swift
//  Ratatouille
//

import SwiftUI

struct CustomLoadButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            Text(title)
                .padding()
                .frame(width: 110, height: 30)
                .foregroundColor(.white)
                .font(.headline.bold())
                .background(LinearGradient(colors: [.customPurpleMedium, .customPurpleDark], startPoint: .top, endPoint: .bottom))
                .cornerRadius(15)
        }
    }
}

#Preview {
    CustomLoadButton(title: "Last inn") {
        print("Button tapped")
    }
}
