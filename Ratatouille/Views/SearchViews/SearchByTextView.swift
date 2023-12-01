//
//  SearchByTextView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 16/11/2023.
//

import SwiftUI

struct SearchByTextView: View {
    
    @ObservedObject var networkManager = NetworkManager.shared
    
    @Binding var searchResults: [SharedSearchResult]
    @Binding var isPresented: Bool
    @State private var searchText: String = ""
    
    var body: some View {
        TextField("Søk etter måltid (Navn)", text: $searchText)
            .padding()
            .border(Color.accentColor, width: 1)
            .frame(maxWidth: 300, alignment: .center)
        
        CustomLoadButton(title: "Søk") {
            networkManager.fetchMealByName(searchWord: searchText) { result in
                self.searchResults = result
                isPresented = false
            }
        }
    }
}

#Preview {
    SearchByTextView(searchResults: .constant([SharedSearchResult]()), isPresented: .constant(false))
}
