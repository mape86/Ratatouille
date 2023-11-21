//
//  MyRecipesView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 14/11/2023.
//

import SwiftUI

struct MyRecipesView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: 
                    MealEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \MealEntity.mealName, ascending: true)]
    ) var meals: FetchedResults<MealEntity>
    
    @State private var showUserAlert = false
    @State private var itemToDelete: MealEntity?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(meals, id: \.self) {meal in
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
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            itemToDelete = meal
                            showUserAlert = true
                        } label: {
                            Label("Slett", systemImage: "trash")
                        }
                    }
                }
                }
                .alert("Du er i ferd med å slette retten fra mine oppskriver, vil du fortsette?",
                       isPresented: $showUserAlert) {
                    Button("Nei, avbryt!", role: .cancel) { itemToDelete = nil }
                    Button("Ja, slett!", role: .destructive) {
                        if let itemToDelete = itemToDelete {
                            viewContext.delete(itemToDelete)
                            try? viewContext.save()
                        }
                        itemToDelete = nil
                    }
                } message: {
                    Text("Oppskriften er slettet!")
                }
                .navigationTitle("Mine oppskrifter")
            }
        }
    }


#Preview {
    MyRecipesView()
}
