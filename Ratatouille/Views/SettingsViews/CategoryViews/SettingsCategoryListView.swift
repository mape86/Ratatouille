//
//  CategoryView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 20/11/2023.
//

import SwiftUI

struct SettingsCategoryListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: CategoryEntity.entity(),
        sortDescriptors: []
    ) var categories: FetchedResults<CategoryEntity>
    
    @ObservedObject var networkManager = NetworkManager.shared
    @State var isLoading: Bool = false
    @State private var showAddView = false
    @State private var showUserAlert = false
    @State private var itemToArchive: CategoryEntity?
    
    var body: some View {
        
        List {
            Button(action: {
                self.showAddView.toggle()
            }) {
                Text("Legg til")
            }
            .sheet(isPresented: $showAddView) {
                AddCategoryView()
            }
            
            ForEach(categories, id: \.self) {category in
                if category.isSaved == true {
                    NavigationLink(destination: EditCategoryView(category: category)){
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
                            Text(category.categoryName ?? "")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                itemToArchive = category
                                showUserAlert = true
                            } label: {
                                Label("Arkiver", systemImage: "archivebox")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Kategorier")
        .onAppear{
            if self.categories.isEmpty {
                loadCategoriesFromAPI()
            }
        }
        .alert(isPresented: $showUserAlert) {
            Alert(
                title: Text("Arkivere Kategorien"),
                message: Text("Er du sikke på at du vil sende denne kategorien til arkivet?"),
                primaryButton: .default(Text("Avbryt")),
                secondaryButton: .destructive(Text("Arkiver"), action: sendToArchive)
            )
        }
    }
    
    //MARK: Functions
    private func loadCategoriesFromAPI() {
        isLoading = true
        networkManager.fetchCategoryList { categoryNames, categoryImages, categoryDescriptions in
            saveCategoryToDB(categoryNames: categoryNames, categoryImages: categoryImages, categoryDescriptions: categoryDescriptions)
        }
    }
    
    private func saveCategoryToDB(categoryNames: [String], categoryImages: [String], categoryDescriptions: [String]) {
        for (index, name) in categoryNames.enumerated() {
            let image = categoryImages[index]
            let description = categoryDescriptions[index]
            
            let newCategory = CategoryEntity(context: viewContext)
            newCategory.categoryName = name
            newCategory.categoryImage = image
            newCategory.categoryDescription = description
            newCategory.isSaved = true
        }
        do {
            try viewContext.save()
        } catch {
            print("Error saving to DB: \(error)")
        }
    }
    
    private func sendToArchive() {
        if let categoryItemToArchive = itemToArchive {
            categoryItemToArchive.isSaved = false
                try? viewContext.save()
        }
    }
}

#Preview {
    SettingsCategoryListView()
}
