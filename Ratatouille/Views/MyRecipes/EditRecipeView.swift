//
//  EditRecipeView.swift
//  Ratatouille
//

import SwiftUI

struct EditRecipeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var meal: MealEntity
    
    @State private var areaToSelect: String
    @State private var categoryToSelect: String
    @State private var newInstructions: String = ""
    @State private var newName: String = ""
    
    @FetchRequest(
        entity: AreaEntity.entity(),
        sortDescriptors: []
    ) var arear: FetchedResults<AreaEntity>
    
    @FetchRequest(
        entity: CategoryEntity.entity(),
        sortDescriptors: []
    ) var categories: FetchedResults<CategoryEntity>
    
    init(meal: MealEntity) {
        self.meal = meal
        _areaToSelect = State(initialValue: meal.mealArea ?? "")
        _categoryToSelect = State(initialValue: meal.mealCategory ?? "")
        _newInstructions = State(initialValue: meal.mealInstructions ?? "")
        _newName = State(initialValue: meal.mealName ?? "")
    }
    
    var body: some View {
        Form {
            
            Section(header: Text("Endre navn:")) {
                TextField("Navn", text: $newName)
            }
            
            Section(header: Text("Endre område eller kategori:")) {
                Picker("Område", selection: $areaToSelect) {
                    ForEach(arear, id: \.self) { area in
                        Text(area.areaName ?? "Ukjent område").tag(area.areaName ?? "")
                    }
                }
                
                Picker("Kategori", selection: $categoryToSelect) {
                    ForEach(categories, id: \.self) { category in
                        Text(category.categoryName ?? "Ukjent kategori").tag(category.categoryName ?? "")
                    }
                }
            }
            
            Section(header: Text("Endre instruksjoner:")) {
                TextEditor(text: $newInstructions)
                    .frame(height: 200)
            }
            
            Section {
                Button("Lagre") {
                    meal.mealArea = areaToSelect
                    meal.mealCategory = categoryToSelect
                    meal.mealInstructions = newInstructions
                    meal.mealName = newName
                    
                    saveMealToDB()
                }
                .foregroundColor(.blue)
                
                Button("Avbryt") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Endre din oppskrift")
    }
    
    private func saveMealToDB() {
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Kunne ikke lagre til databasen..: \(error.localizedDescription)")
        }
    }
}

//#Preview {
//    
//    let context = PersistenceController.preview.container.viewContext
//    EditRecipeView(meal: <#MealEntity#>)
//}
