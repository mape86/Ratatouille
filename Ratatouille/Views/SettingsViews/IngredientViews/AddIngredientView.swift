//
//  AddIngredientView.swift
//  Ratatouille
//

import SwiftUI

struct AddIngredientView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newIngredientName: String = ""
    @State private var newIngredientType: String = ""
    @State private var newDescription: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Navn:")) {
                TextField("Navn", text: $newIngredientName)
            }
            
            Section(header: Text("Type:")) {
                TextEditor(text: $newIngredientType)
                    .frame(height: 50)
            }
            
            Section(header: Text("Beskrivelse:")) {
                TextEditor(text: $newDescription)
                    .frame(height: 200)
            }
            
            Section {
                Button("Lagre") {
                    let newIngredient = IngredientEntity(context: viewContext)
                    newIngredient.ingredientName = newIngredientName
                    newIngredient.ingredientType = newIngredientType
                    newIngredient.ingredientDescription = newDescription
                    newIngredient.isSaved = true
                    
                    try? viewContext.save()
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
                    
                Button("Avbryt") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Legg til ingrediens")
        }
    }
}

#Preview {
    AddIngredientView()
}
