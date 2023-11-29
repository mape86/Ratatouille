//
//  ArchiveView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 20/11/2023.
//

import SwiftUI

struct ArchiveView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: MealEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MealEntity.mealName, ascending: true)],
        predicate: NSPredicate(format: "isSaved == false")
    ) var archivedMeals: FetchedResults<MealEntity>
    
    @State private var showUserAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Landområder")) {
                List {
                    Text("Norge")
                    Text("Sverige")
                }
            }
            
            Section(header: Text("Kategorier")) {
                List {
                    Text("Frokost")
                    Text("Lunsj")
                }
            }
            
            Section(header: Text("Ingredienser")) {
                List {
                    Text("Kjøtt")
                }
            }
            
            Section(header: Text("Mine Oppskrifter")) {
                List {
                    ForEach(archivedMeals) {meal in
                        HStack{
                            if let mealImage = meal.mealImage, let url = URL(string: mealImage) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(10)
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(10)
                            }
                            Text(meal.mealName ?? "Ukjent måltid")
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                meal.isSaved = true
                                try? viewContext.save()
                            } label: {
                                Label("Gjenopprett", systemImage: "plus")
                            }
                            .tint(.green)
                            
                            Button(role: .destructive) {
                                viewContext.delete(meal)
                                try? viewContext.save()
                            } label: {
                                Label("Slett", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Administrere Arkiv")
    }
}

#Preview {
    ArchiveView()
}
