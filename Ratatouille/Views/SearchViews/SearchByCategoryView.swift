//
//  SearchByCategoryView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 16/11/2023.
//

import SwiftUI

struct SearchByCategoryView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var searchTerm: ([SharedSearchResult]) -> Void
    @ObservedObject var networkManager = NetworkManager.shared
    @State private var categoryList: [String] = []
    @State private var chosenCategory: String = ""
    
    @Binding var isPresented: Bool
    
    
    var body: some View {
        VStack {
            Text("Søk kategori")
                .font(.title.bold())
                .foregroundStyle(LinearGradient(colors: [.pink, .purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
            CustomLoadButton(title: "Last inn kategorier") {
                networkManager.fetchCategoryList{
                    if let firstCategory = networkManager.categories.first {
                        chosenCategory = firstCategory.strCategory
                    }
                }
                
            }
            if !networkManager.categories.isEmpty {
                Picker("Velg område å søke fra", selection: $chosenCategory) {
                    ForEach(networkManager.categories, id: \.id) {category in
                        Text(category.strCategory).tag(category.strCategory)
                    }
                }
            }
            //            .onAppear{
            //                networkManager.fetchAreaList()
            //            }
            
        }
        
        Button("Søk") {
            networkManager.fetchMealsByCategory(category: chosenCategory) { categoryName in
                searchTerm(categoryName)
                isPresented = false
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.gray.opacity(0.5)))
    }
}

#Preview {
    SearchByCategoryView(
        searchTerm: { _ in print("Søket er utført")},
        isPresented: .constant(true)
    )
}
