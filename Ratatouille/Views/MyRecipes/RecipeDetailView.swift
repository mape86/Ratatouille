//
//  RecipeDetailView.swift
//  Ratatouille
//

import SwiftUI

struct RecipeDetailView: View {
    
    let id: String
    @State private var recipe: Meal?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @ObservedObject var networkManager = NetworkManager.shared
    
    var body: some View {
        Group {
            ZStack{
                RadialGradient(stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45) ,location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                ], center: .top, startRadius: 200, endRadius: 700)

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
                                .font(.title.bold())
                                .padding(.top, 10)
                                                        
                            HStack{
                                Text("Kategori:")
                                    .bold()
                                Text(recipe.strCategory)
                            }
                            .font(.title3)
                            .padding(.top, 10)
                            
                            HStack{
                                Text("Område:")
                                    .bold()
                                Text(recipe.strArea)
                            }
                            .font(.title3)
                            .padding(.top, 10)
                            
                            HStack {
                                Text("Slik gjør du:")
                                    .font(.title3.bold())
                                    .padding(.top, 10)
                                Spacer()
                                if let youtube = recipe.strYoutube {
                                    VStack{
                                        Image("youtubeLogo")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                        Link("Se på YouTube", destination: URL(string: youtube) ?? URL(string: "https://www.youtube.com")!)
                                    }
                                }

                            }
                            Text(recipe.strInstructions)
                                .padding(.top, 10)
                        }
                        .padding()
                        .background(.regularMaterial)
                    }
                } else if let errorMsg = errorMessage {
                    Text(errorMsg)
                } else {
                    ProgressView()
                }
            }
            
        }
        .navigationTitle("Oppskrifts detaljer")
        .onAppear {
            fetchRecipeDetail()
        }
    }
    

    private func fetchRecipeDetail() {
        
        isLoading = true
        
          networkManager.fetchMealDetailsByID(mealId: id) { result in
              DispatchQueue.main.async {
                  isLoading = false
                  switch result {
                  case .success(let meal):
                      self.recipe = meal
                  case .failure(let error):
                      self.errorMessage = error.localizedDescription
                  }
              }
          }
      }
}


#Preview {
    RecipeDetailView(id: "")
}
