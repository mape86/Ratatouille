//
//  EditIngredientView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 20/11/2023.
//

import SwiftUI
import CoreData

struct SettingsIngredientListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: IngredientEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \IngredientEntity.ingredientName, ascending: true)]
    ) var ingredients: FetchedResults<IngredientEntity>
    
    @ObservedObject var networkManager = NetworkManager.shared
    @State var isLoading: Bool = false
    @State private var showUserAlert = false
    @State private var showAddView = false
    @State private var itemToArchive: IngredientEntity?
    @State private var addNewIngredientName: String = ""
    
    var body: some View {
        List {
            Button(action: {
                self.showAddView.toggle()
            }) {
                Text("Legg til")
            }
            .sheet(isPresented: $showAddView) {
                AddIngredientView()
            }
            
            ForEach(ingredients, id: \.self) {ingredient in
                if ingredient.isSaved == true {
                    NavigationLink(destination: EditIngredientView(ingredient: ingredient)){
                        HStack {
                            
                                AsyncImage(url: URL(string: "https://www.themealdb.com/images/ingredients/\(ingredient.ingredientName ?? "Lime")-Small.png")) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(10)
                                } placeholder: {
                                    ProgressView()
                                }
                            Text(ingredient.ingredientName ?? "Ukjent ingrediens")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                itemToArchive = ingredient
                                showUserAlert = true
                            } label: {
                                Label("Arkiver", systemImage: "archivebox")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Ingredienser")
        .onAppear{
            if self.ingredients.isEmpty {
                loadIngredientsFromAPI()
            }
        }
        .alert(isPresented: $showUserAlert) {
            Alert(
                title: Text("Arkivere Ingrediensen"),
                message: Text("Er du sikke på at du vil sende denne ingrediensen til arkivet?"),
                primaryButton: .default(Text("Avbryt")),
                secondaryButton: .destructive(Text("Arkiver"), action: sendToArchive)
            )
        }
    }
    
    //MARK: Functions
    private func loadIngredientsFromAPI() {
        isLoading = true
        networkManager.fetchIngredientList { ingredientNames, ingredientDescription, ingredientType in
            saveIngredientsToDB(ingredientNames: ingredientNames, ingredientDescription: ingredientDescription, ingredientType: ingredientType)
        }
    }
    
    private func saveIngredientsToDB(ingredientNames: [String], ingredientDescription: [String?], ingredientType: [String?]) {
        for (index, name) in ingredientNames.enumerated() {
            let description = ingredientDescription[index] ?? "Ingen Beskrivelse"
            let type = ingredientType[index] ?? "Ingen Type"
            
            let newIngredient = IngredientEntity(context: viewContext)
            newIngredient.ingredientName = name
            newIngredient.ingredientDescription = description
            newIngredient.ingredientType = type
            newIngredient.isSaved = true
        }
        do {
            try viewContext.save()
        } catch {
            print("Error saving to DB: \(error)")
        }
    }
    
    private func sendToArchive() {
        if let ingredientItemToArchive = itemToArchive {
            ingredientItemToArchive.isSaved = false
                try? viewContext.save()
        }
    }
}

#Preview {
    SettingsIngredientListView()
}
