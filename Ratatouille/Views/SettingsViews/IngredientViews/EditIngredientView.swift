//
//  EditIngredientView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 01/12/2023.
//

import SwiftUI

struct EditIngredientView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var ingredient: IngredientEntity
    @State private var newIngredientName: String = ""
    @State private var newIngredientDescription: String = ""
    @State private var newIngredientType: String = ""
    
    init(ingredient: IngredientEntity) {
        self.ingredient = ingredient
        _newIngredientName = State(initialValue: ingredient.ingredientName ?? "")
        _newIngredientDescription = State(initialValue: ingredient.ingredientDescription ?? "")
        _newIngredientType = State(initialValue: ingredient.ingredientType ?? "")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Rediger navn:")) {
                TextField("Navn", text: $newIngredientName)
            }
            
            
            Section(header: Text("Rediger ingrediens beskrivelse og type")) {
                TextEditor(text: $newIngredientType)
                    .frame(height: 40)
                    .padding(.bottom, 10)
                TextEditor(text: $newIngredientDescription)
                    .frame(height: 200)
            }

            
            Section {
                Button("Lagre") {
    
                    if ingredient.ingredientName != newIngredientName {
                        ingredient.ingredientName = newIngredientName
                        ingredient.ingredientType = newIngredientType
                        ingredient.ingredientDescription = newIngredientDescription
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
        .navigationTitle("Rediger ingrediens")
    }
}

#Preview {
    EditIngredientView(ingredient: IngredientEntity())
}
