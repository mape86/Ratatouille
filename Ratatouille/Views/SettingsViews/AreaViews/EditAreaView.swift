//
//  EditAreaView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 29/11/2023.
//

import SwiftUI
import CoreData

struct EditAreaView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var area: AreaEntity
    @State private var newAreaName: String = ""
    
//    @FetchRequest(
//        entity: AreaEntity.entity(),
//        sortDescriptors: []
//    ) var areas: FetchedResults<AreaEntity>
    
    
    
    init(area: AreaEntity) {
        self.area = area
        _newAreaName = State(initialValue: area.areaName ?? "")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Endre navn:")) {
                TextField("Navn", text: $newAreaName)
            }
            
            Section {
                Button("Lagre") {
                    if area.areaName != newAreaName {
                        updateMealAreas(originalName: area.areaName, newName: newAreaName)
                        area.areaName = newAreaName
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
        .navigationTitle("Rediger område")
    }
    
    private func updateMealAreas(originalName: String?, newName: String) {
        let fetchRequest: NSFetchRequest<MealEntity> = MealEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mealArea == %@", originalName ?? "")
        
        do {
            let mealsToBeUpdated = try viewContext.fetch(fetchRequest)
            for meal in mealsToBeUpdated {
                meal.mealArea = newName
            }
            try viewContext.save()
        } catch {
            print("Feilet ved endring av områdenavn: \(error.localizedDescription)")
        }
    }
}

#Preview {
    EditAreaView(area: AreaEntity())
}
