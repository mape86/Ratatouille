//
//  AddCategoryView.swift
//  Ratatouille
//

import SwiftUI

struct AddCategoryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newCategoryName: String = ""
    @State private var newCategoryImageURL: String = ""
    @State private var newDescription: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Navn:")) {
                TextField("Navn", text: $newCategoryName)
            }
            
            Section(header: Text("Bilde:")) {
                TextEditor(text: $newCategoryImageURL)
                    .frame(height: 50)
            }
            
            Section(header: Text("Beskrivelse:")) {
                TextEditor(text: $newDescription)
                    .frame(height: 200)
            }
            
            Section {
                Button("Lagre") {
                    let newCategory = CategoryEntity(context: viewContext)
                    newCategory.categoryName = newCategoryName
                    newCategory.categoryImage = newCategoryImageURL
                    newCategory.categoryDescription = newDescription
                    newCategory.isSaved = true
                    
                    try? viewContext.save()
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
                    
                Button("Avbryt") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Legg til kategori")
        }
    }
}

#Preview {
    AddCategoryView()
}
