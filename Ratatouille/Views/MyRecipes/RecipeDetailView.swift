//
//  RecipeDetailView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 20/11/2023.
//

import SwiftUI

struct RecipeDetailView: View {
    
    let id: String
    @State private var recipe: Meal?
    @State private var isLoading = true
    @State private var errorMsg: String?
    @ObservedObject var networkManager = NetworkManager.shared
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Laster inn...")
            } else if let recipe = recipe {
                ScrollView {
                    VStack(alignment: .leading) {
                        if let url = URL(string: recipe.strMealThumb) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        Text(recipe.strMeal)
                            .font(.title)
                            .bold()
                            .padding(.top, 10)
                        Text("Kategori: \(recipe.strCategory)")
                            .font(.title3)
                            .padding(.top, 10)
                        Text("Område: \(recipe.strArea)")
                            .font(.title3)
                            .padding(.top, 10)
                        Text("Slik gjør du:")
                            .font(.title3)
                            .padding(.top, 10)
                        Text(recipe.strInstructions)
                            .padding(.top, 10)
                    }
                    .padding()
                }
            } else if let errorMsg = errorMsg {
                Text(errorMsg)
            } else {
                ProgressView()
            }
            
        }
        .navigationTitle("Oppskrifts detaljer")
        .onAppear {
            fetchRecipeDetail()
        }
    }
    

    private func fetchRecipeDetail() {
        isLoading = true
        print("Id = \(id)")
        
          networkManager.fetchMealDetailsByID(mealId: id) { result in
              DispatchQueue.main.async {
                  isLoading = false
                  switch result {
                  case .success(let meal):
                      self.recipe = meal
                  case .failure(let error):
                      self.errorMsg = error.localizedDescription
                  }
              }
          }
      }
}


#Preview {
    RecipeDetailView(id: "")
}
