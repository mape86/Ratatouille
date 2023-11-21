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
    @State private var isShowingAlert = false
    
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
                Picker("Velg ingrediens", selection: $chosenIngredient) {
                    ForEach(ingredients, id: \.self) {ingredient in
                        Text(ingredient.ingredientName ?? "").tag(ingredient.ingredientName ?? "")
                    }
                }
            }
            HStack {
                Spacer()
                VStack {
                    CustomLoadButton(title: "last inn") {
                        loadIngredientsFromAPI()
                    }
                    Text("Last inn fra API")
                        .font(.callout)
                }
                Spacer()
                VStack{
                    CustomLoadButton(title: "Slett") {
                        self.isShowingAlert = true
                    }
                    .alert(isPresented: $isShowingAlert) {
                        Alert(
                            title: Text("Advarsel"),
                            message: Text("Du er i ferd med å slette hele listen fra databasen. Vil du fortsette?"),
                            primaryButton: .destructive(Text("Slett")) {
                                deleteIngredientListFromDB()
                            },
                            secondaryButton: .cancel(Text("Avbryt"))
                        )
                    }
                    Text("Slett fra database")
                }
                Spacer()
            }
        }
        .onAppear{
            fetchIngredientsFromDB()
        }
        
        CustomLoadButton(title: "Søk") {
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
