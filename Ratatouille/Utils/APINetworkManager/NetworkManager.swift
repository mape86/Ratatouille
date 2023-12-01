//
//  NetworkManager.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 15/11/2023.
//

import Foundation
import SwiftUI

final class NetworkManager: ObservableObject {
    
    static let shared = NetworkManager()
    
    //Lists
//    @Published var areas: [MealAreaList] = []
    @Published var categories: [MealCategoryList] = []
    @Published var ingredientsList: [MealIngredientList] = []
    
    //MARK: Search URLs
    //List and filter by areas
    private let areaListURL = "https://www.themealdb.com/api/json/v1/1/list.php?a=list"
    private let filterByAreaURL = "https://www.themealdb.com/api/json/v1/1/filter.php?a="
    
    //List of all categories
    private let categoryListURL = "https://www.themealdb.com/api/json/v1/1/list.php?c=list"
    
    //List and filter by category
    private let categoryFilterURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
    private let listAllMealCategoriesURL = "https://www.themealdb.com/api/json/v1/1/categories.php"
    
    //List and filter by ingredients
    private let ingredientListURL = "https://www.themealdb.com/api/json/v1/1/list.php?i=list"
    private let filterByIngredientURL = "https://www.themealdb.com/api/json/v1/1/filter.php?i="
    private let ingredientImageURL = "https://www.themealdb.com/images/ingredients/"
    
    //Search by name
    private let searchByNameURL = "https://www.themealdb.com/api/json/v1/1/search.php?s="
    //MARK: Detail URLS
    private let mealDetailURL = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
    
    
    private init () {}
        
    //MARK: Area Functions
    
    func fetchAreaList(completed: @escaping ([String]) -> Void) {
        guard let url = URL(string: areaListURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {  data, response, error in
            guard let data = data, error == nil else {
                print("Feil ved nettverskforespørsel: \(error?.localizedDescription ?? "Ukjent feil")")
                completed([])
                return}
            
            do {
                let decoder = JSONDecoder()
                let areaResponse = try decoder.decode(MealAreaListResponse.self, from: data)
                let areaNames = areaResponse.meals.map { $0.strArea}
                
                DispatchQueue.main.async {
                    completed(areaNames)
                }
            }catch {
                print("Feilet ved dekoding \(error.localizedDescription)")
                completed([])
            }
        }.resume()
    }

    
    func fetchMealsByArea(area: String, completed: @escaping ([SharedSearchResult]) -> Void) {
        let urlString = "\(filterByAreaURL)\(area)"
        guard let url = URL(string: urlString) else {
            print("Error: Ugyldig URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Forespørsel til nettverk feilet: \(error?.localizedDescription ?? "Ukjent feil") ")
                DispatchQueue.main.async {
                    completed([])
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let filteredAreaResponse = try decoder.decode(MealAreaResponse.self, from: data)
                let searchResult = filteredAreaResponse.meals.map { area in

                   return SharedSearchResult(id: area.idMeal, name: area.strMeal, thumb: area.strMealThumb, description: nil, type: nil)
                }
                DispatchQueue.main.async {
                    completed(searchResult)
                }
            }catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completed([])
                }
            }
        }.resume()
    }
    
    //MARK: Category Functions
    
    func fetchCategoryList(completed: @escaping ([String], [String], [String]) -> Void) {
        guard let url = URL(string: listAllMealCategoriesURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Feil ved nettverskforespørsel: \(error?.localizedDescription ?? "Ukjent feil")")
                completed([], [], [])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let categoryResponse = try decoder.decode(MealCategoryResponse.self, from: data)
                let categoryNames = categoryResponse.categories.map {$0.strCategory}
                let categoryImage = categoryResponse.categories.map {$0.strCategoryThumb}
                let categoryDescription = categoryResponse.categories.map {$0.strCategoryDescription}
                DispatchQueue.main.async {
                    completed(categoryNames, categoryImage, categoryDescription)
                }
            }catch {
                print("Feilet ved dekoding. \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func fetchMealsByCategory(category: String, completed: @escaping ([SharedSearchResult]) -> Void) {
        let urlString = "\(categoryFilterURL)\(category)"
        guard let url = URL(string: urlString) else {
            print("Error: Ugyldig URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Forespørsel til nettverk feilet: \(error?.localizedDescription ?? "Ukjent feil") ")
                DispatchQueue.main.async {
                    completed([])
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let filteredCategoryResponse = try decoder.decode(FilteredCategoryResponse.self, from: data)
                let searchResult = filteredCategoryResponse.meals.map { category in
                    
                    return SharedSearchResult(id: category.idMeal, name: category.strMeal, thumb: category.strMealThumb,description: nil, type: nil)
                }
                DispatchQueue.main.async {
                    completed(searchResult)
                }
            }catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completed([])
                }
            }
        }.resume()
    }
    
    //MARK: Ingredient Functions
    
    func fetchIngredientList(completed: @escaping ([String], [String?], [String?]) -> Void) {
        guard let url = URL(string: ingredientListURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Feil ved nettverskforespørsel: \(error?.localizedDescription ?? "Ukjent feil")")
                completed([], [], [])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let ingredientResponse = try decoder.decode(MealIngredientResponse.self, from: data)
                let ingredientNames = ingredientResponse.meals.map { $0.strIngredient}
                let ingredientType = ingredientResponse.meals.map { $0.strType}
                let ingredientDescription = ingredientResponse.meals.map { $0.strDescription}
                DispatchQueue.main.async {
                    completed(ingredientNames, ingredientDescription, ingredientType)
                }
            }catch {
                print("Feilet ved dekoding. \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func fetchMealsByIngredient(ingredient: String, completed: @escaping ([SharedSearchResult]) -> Void) {
        let urlString = "\(filterByIngredientURL)\(ingredient)"
        guard let url = URL(string: urlString) else {
            print("Error: Ugyldig URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Forespørsel til nettverk feilet: \(error?.localizedDescription ?? "Ukjent feil") ")
                DispatchQueue.main.async {
                    completed([])
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let filteredIngredientResponse = try decoder.decode(FilteredIngredientResponse.self, from: data)
                let searchResult = filteredIngredientResponse.meals.map { ingredient in
                    SharedSearchResult(id: ingredient.idMeal, name: ingredient.strMeal, thumb: ingredient.strMealThumb, description: nil, type: nil)
                }
                DispatchQueue.main.async {
                    completed(searchResult)
                }
            }catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completed([])
                }
            }
        }.resume()
    }
    
    func fetchMealByName(searchWord: String, completed: @escaping ([SharedSearchResult]) -> Void) {
        let urlString = "\(searchByNameURL)\(searchWord)"
        guard let url = URL(string: urlString) else {
            print("Error: Ugyldig URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Forespørsel til nettverk feilet: \(error?.localizedDescription ?? "Ukjent feil") ")
                DispatchQueue.main.async {
                    completed([])
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let filteredIngredientResponse = try decoder.decode(MealResponse.self, from: data)
                let searchResult = filteredIngredientResponse.meals.map { ingredient in
                    SharedSearchResult(id: ingredient.idMeal, name: ingredient.strMeal, thumb: ingredient.strMealThumb, description: nil, type: nil)
                }
                DispatchQueue.main.async {
                    completed(searchResult)
                }
            }catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completed([])
                }
            }
        }.resume()
    }
    
    //MARK: Meal detail functions
    
    func fetchMealDetailsByID(mealId: String, completed: @escaping (Result <Meal, Error>) -> Void) {
        let detailURL = mealDetailURL + mealId
        guard let url = URL(string: detailURL) else {
            completed(.failure(NMError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completed(.failure(error))
                }
                
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completed(.failure(NMError.invalidData))
                }
                
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let mealResponse = try decoder.decode(MealResponse.self, from: data)
                DispatchQueue.main.async {
                    if let meal = mealResponse.meals.first {
                        completed(.success(meal))
                    } else {
                        completed(.failure(NMError.invalidResponse))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completed(.failure(error))
                }
            }
        }.resume()
    }
}
