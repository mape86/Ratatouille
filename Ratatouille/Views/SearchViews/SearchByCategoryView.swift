//
//  SearchByCategoryView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 16/11/2023.
//

import SwiftUI
import CoreData

//MARK: Main view
struct SearchByCategoryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var searchTerm: ([SharedSearchResult]) -> Void
    
    @ObservedObject var networkManager = NetworkManager.shared
    
    @State private var chosenCategory: String = ""
    @State private var categories: [CategoryEntity] = []
    @State private var isLoading: Bool = false
    @State private var isShowingAlert = false
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text("Søk kategori")
                .font(.title.bold())
                .foregroundStyle(LinearGradient(colors: [.customPurpleDark, .customPurpleMedium], startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
    
            HStack {
                
                Spacer()
                
                VStack {
                    CustomLoadButton(title: "last inn") {
                        if categories.isEmpty {
                            loadCategoriesFromAPI()
                        } else {
                            print("Allerede lastet inn")
                        }
                    }
                    Text("fra API")
                        .font(.callout)
                }
                
                Spacer()
                
                VStack{
                    CustomLoadButton(title: "Slett") {
                        self.isShowingAlert = true
                    }
                    .alert(isPresented: $isShowingAlert) {
                        Alert(
                            title: Text("Advarsel"),
                            message: Text("Du er i ferd med å slette hele listen fra databasen. Vil du fortsette?"),
                            primaryButton: .destructive(Text("Slett")) {
                                deleteCategoryListFromDB()
                            },
                            secondaryButton: .cancel(Text("Avbryt"))
                        )
                    }
                    Text("fra database")
                        .font(.callout)
                }
                
                Spacer()
            }
        }
        .onAppear{
            fetchCategoriesFromDB()
        }
        
        Spacer()
        
        VStack{
            CustomLoadButton(title: "Søk") {
                networkManager.fetchMealsByCategory(category: chosenCategory) { categoryName in
                    searchTerm(categoryName)
                    isPresented = false
                }
            }
            if isLoading {
                ProgressView("Laster inn områder...")
            } else {
                Picker("Velg kategori", selection: $chosenCategory) {
                    ForEach(categories, id: \.self) {category in
                        if category.isSaved == true {
                            Text(category.categoryName ?? "").tag(category.categoryName ?? "")
                        }
                    }
                }
            }
        }
        
        Spacer()
    }
    
    //MARK: Functions
    
    private func loadCategoriesFromAPI() {
        isLoading = true
        networkManager.fetchCategoryList { categoryNames, categoryImages, categoryDescriptions in
            saveCategoriesToDB(categoryNames: categoryNames, categoryImages: categoryImages, categoryDescriptions: categoryDescriptions)
        }
    }
    
    private func saveCategoriesToDB(categoryNames: [String], categoryImages: [String], categoryDescriptions: [String]) {
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
            fetchCategoriesFromDB()
        } catch {
            print("Feilet ved lagring til databasen. \(error)")
        }
        isLoading = false
    }
    
    private func fetchCategoriesFromDB() {
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        
        do {
            categories = try viewContext.fetch(fetchRequest)
            if let firstCategory = categories.first {
                chosenCategory = firstCategory.categoryName ?? ""
            }
        } catch {
            print("Feilet ved henting av kategorier fra DB. \(error)")
        }
    }
    
    private func deleteCategoryListFromDB() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CategoryEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
            categories = []
            chosenCategory = ""
        } catch {
            print("Feilet ved sletting av kategorier fra databasen. \(error)")
        }
    }
}

#Preview {
    SearchByCategoryView(
        searchTerm: { _ in print("Søket er utført")},
        isPresented: .constant(true)
    )
}
