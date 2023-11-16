//
//  SearchByIngredientView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 16/11/2023.
//

import SwiftUI

struct SearchByIngredientView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var searchTerm: ([String]) -> Void
    @ObservedObject var networkManager = NetworkManager.shared
    @State private var ingredientList: [String] = []
    @State private var chosenIngredient: String = ""
    
    @Binding var isPresented: Bool
    
    
    var body: some View {
        VStack {
            Text("Søk ingrediens")
                .font(.title.bold())
                .foregroundStyle(LinearGradient(colors: [.pink, .purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
            CustomLoadButton(title: "Last inn ingredienser") {
                networkManager.fetchIngredientList{
                    if let firstIngredient = networkManager.ingredientsList.first {
                        chosenIngredient = firstIngredient.strIngredient
                    }
                }
                
            }
            
            if !networkManager.ingredientsList.isEmpty {
                Picker("Velg område å søke fra", selection: $chosenIngredient) {
                    ForEach(networkManager.ingredientsList, id: \.id) {ingredient in
                        Text(ingredient.strIngredient).tag(ingredient.strIngredient)
                    }
                }
            }
            //            .onAppear{
            //                networkManager.fetchAreaList()
            //            }
            
        }
        
        Button("Søk") {
            let results = ["Test område 1", "test område 2"]
            searchTerm(results)
            isPresented = false
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.gray.opacity(0.5)))
    }
}

#Preview {
    SearchByIngredientView(
        searchTerm: { _ in print("Søket er utført")},
        isPresented: .constant(true)
    )
}
