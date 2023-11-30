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
    @State private var itemToArchive: IngredientEntity?
    @State private var addNewIngredientName: String = ""
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SettingsIngredientListView()
}
