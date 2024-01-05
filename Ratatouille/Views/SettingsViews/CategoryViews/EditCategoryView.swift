//
//  EditCategoryView.swift
//  Ratatouille
//

import SwiftUI
import CoreData

struct EditCategoryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var category: CategoryEntity
    @State private var newCategoryName: String = ""
    @State private var newImageURL: String = ""
    @State private var newDescription: String = ""
    
    init(category: CategoryEntity) {
        self.category = category
        _newCategoryName = State(initialValue: category.categoryName ?? "")
        _newImageURL = State(initialValue: category.categoryImage ?? "")
        _newDescription = State(initialValue: category.categoryDescription ?? "")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Rediger navn:")) {
                TextField("Navn", text: $newCategoryName)
            }
            
            Section(header: Text("Rediger bilde url")) {
                TextEditor(text: $newImageURL)
                    .frame(height: 45)
            }

            Section(header: Text("Rediger beskrivelse")) {
                TextEditor(text: $newDescription)
                    .frame(height: 200)
            }
            
            Section {
                Button("Lagre") {
    
                    if category.categoryName != newCategoryName {
                        updateMealCategories(originalName: category.categoryName, newName: newCategoryName)
                        category.categoryName = newCategoryName
                        category.categoryImage = newImageURL
                        category.categoryDescription = newDescription
                        try? viewContext.save()
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
                    
                Button("Avbryt") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Rediger kategori")
    }
    
    private func updateMealCategories(originalName: String?, newName: String) {
        let fetchRequest: NSFetchRequest<MealEntity> = MealEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mealCategory == %@", originalName ?? "")
        
        do {
            let mealsToBeUpdated = try viewContext.fetch(fetchRequest)
            for meal in mealsToBeUpdated {
                meal.mealCategory = newName
            }
            try viewContext.save()
        } catch {
            print("Feilet ved endring av områdenavn: \(error.localizedDescription)")
        }
    }
}

#Preview {
    EditCategoryView(category: CategoryEntity())
}
