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
    
    @FetchRequest(
        entity: AreaEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \AreaEntity.areaName, ascending: true)],
        predicate: NSPredicate(format: "isSaved == false")
    ) var areas: FetchedResults<AreaEntity>
    
    @FetchRequest(
        entity: CategoryEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.categoryName, ascending: true)],
        predicate: NSPredicate(format: "isSaved == false")
    ) var categories: FetchedResults<CategoryEntity>
    
    @FetchRequest(
        entity: IngredientEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \IngredientEntity.ingredientName, ascending: true)],
        predicate: NSPredicate(format: "isSaved == false")
    ) var ingredients: FetchedResults<IngredientEntity>
    
    @State private var showUserAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Landområder")) {
                List {
                    ForEach(areas) { area in
                        HStack{
                            Text(area.areaName ?? "Ukjent område")
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                area.isSaved = true
                                try? viewContext.save()
                            } label: {
                                Label("Gjenopprett", systemImage: "plus")
                            }
                            .tint(.green)
                            
                            Button(role: .destructive) {
                                viewContext.delete(area)
                                try? viewContext.save()
                            } label: {
                                Label("Slett", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Kategorier")) {
                List {
                    ForEach(categories) { category in
                        HStack {
                            if let categoryImage = category.categoryImage, let url = URL(string: categoryImage) {
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
                            Text(category.categoryName ?? "Ukjent kategori")
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                category.isSaved = true
                                try? viewContext.save()
                            } label: {
                                Label("Gjenopprett", systemImage: "plus")
                            }
                            .tint(.green)
                            
                            Button(role: .destructive) {
                                viewContext.delete(category)
                                try? viewContext.save()
                            } label: {
                                Label("Slett", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Ingredienser")) {
                List {
                    ForEach(ingredients) { ingredient in
                        HStack {
                            if let url = URL(string: "https://www.themealdb.com/images/ingredients/\(ingredient.ingredientName ?? "")-Small.png") {
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
                            Text(ingredient.ingredientName ?? "Ukjent ingrediens")
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                ingredient.isSaved = true
                                try? viewContext.save()
                            } label: {
                                Label("Gjenopprett", systemImage: "plus")
                            }
                            .tint(.green)
                            
                            Button(role: .destructive) {
                                viewContext.delete(ingredient)
                                try? viewContext.save()
                            } label: {
                                Label("Slett", systemImage: "trash")
                            }
                        }
                    }
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
