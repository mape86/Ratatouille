//
//  SearchByIngredientView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 16/11/2023.
//

import SwiftUI
import CoreData

struct SearchByIngredientView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var searchTerm: ([SharedSearchResult]) -> Void
    
    @ObservedObject var networkManager = NetworkManager.shared
    
    @State private var ingredients: [IngredientEntity] = []
    @State private var chosenIngredient: String = ""
    @State private var isLoading: Bool = false
    
    @Binding var isPresented: Bool
    
    
    var body: some View {
        VStack {
            Text("Søk ingrediens")
                .font(.title.bold())
                .foregroundStyle(LinearGradient(colors: [.pink, .purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
            
            if isLoading {
                ProgressView("Laster inn områder...")
            } else {
                Picker("Velg område å søke fra", selection: $chosenIngredient) {
                    ForEach(ingredients, id: \.self) {ingredient in
                        Text(ingredient.ingredientName ?? "").tag(ingredient.ingredientName ?? "")
                    }
                }
            }
            CustomLoadButton(title: "last inn områder fra API") {
                loadIngredientsFromAPI()
            }
            CustomLoadButton(title: "Slett listen fra databasen") {
                deleteIngredientListFromDB()
            }
        }
        .onAppear{
            fetchIngredientsFromDB()
        }
        
        Button("Søk") {
            networkManager.fetchMealsByIngredient(ingredient: chosenIngredient) { ingredientName in
                searchTerm(ingredientName)
                isPresented = false
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.gray.opacity(0.5)))
    }
    
    //MARK: Functions
    
    private func loadIngredientsFromAPI() {
        isLoading = true
        networkManager.fetchIngredientList { ingredientNames in
            saveIngredientsToDB(ingredientNames: ingredientNames)
        }
    }
    
    private func saveIngredientsToDB(ingredientNames: [String]) {
        ingredientNames.forEach { ingredientName in
            let newIngredient = IngredientEntity(context: viewContext)
            newIngredient.ingredientName = ingredientName
        }
        do {
            try viewContext.save()
            fetchIngredientsFromDB()
        } catch {
            print("Feilet ved lagring til databasen. \(error)")
        }
        isLoading = false
    }
    
    private func fetchIngredientsFromDB() {
        let fetchRequest: NSFetchRequest<IngredientEntity> = IngredientEntity.fetchRequest()
        
        do {
            ingredients = try viewContext.fetch(fetchRequest)
            if let firstIngredient = ingredients.first {
                chosenIngredient = firstIngredient.ingredientName ?? ""
            }
        } catch {
            print("Feilet ved henting av kategorier fra DB. \(error)")
        }
    }
    
    private func deleteIngredientListFromDB() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "IngredientEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
            ingredients = []
            chosenIngredient = ""
        } catch {
            print("Feilet ved sletting av kategorier fra databasen. \(error)")
        }
    }
}

#Preview {
    SearchByIngredientView(
        searchTerm: { _ in print("Søket er utført")},
        isPresented: .constant(true)
    )
}
