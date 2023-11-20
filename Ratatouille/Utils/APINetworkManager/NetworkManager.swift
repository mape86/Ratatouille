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
    @Published var areas: [MealAreaList] = []
    @Published var categories: [MealCategoryList] = []
    @Published var ingredientsList: [MealIngredientList] = []
    
    //MARK: Area URLS
    //List of all areas
    private let areaListURL = "https://www.themealdb.com/api/json/v1/1/list.php?a=list"
    private let filterByAreaURL = "https://www.themealdb.com/api/json/v1/1/filter.php?a="
    
    //MARK: Category URLS
    //List of all categories
    private let categoryListURL = "https://www.themealdb.com/api/json/v1/1/list.php?c=list"
    //Filter by category
    private let categoryFilterURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
    private let listAllMealCategoriesURL = "https://www.themealdb.com/api/json/v1/1/categories.php"
    
    //MARK: Ingredient URLS
    //List of all ingredients
    private let ingredientListURL = "https://www.themealdb.com/api/json/v1/1/list.php?i=list"
    private let filterByIngredientURL = "https://www.themealdb.com/api/json/v1/1/filter.php?i="
    private let ingredientImageURL = "https://www.themealdb.com/images/ingredients/"
    
    //MARK: Detail URLS
    private let mealDetailURL = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
    
    
    private init () {}
    
    //MARK: Flag conversion function
    var areaToCountryCode: [String: String] = [ : ]
    
    func areaNameToCountryCode(_ areaName: String) -> String? {
        
        let areaMapping = [
            "American": "US",
            "British": "GB",
            "Canadian": "CA",
            "Chinese": "CN",
            "Dutch": "NL",
            "Egyptian": "EG",
            "French": "FR",
            "Greek": "GR",
            "Indian": "IN",
            "Irish": "IE",
            "Italian": "IT",
            "Jamaican": "JM",
            "Japanese": "JP",
            "Kenyan": "KE",
            "Malaysian": "MY",
            "Mexican": "MX",
            "Moroccan": "MA",
            "Polish": "PL",
            "Portuguese": "PT",
            "Russian": "RU",
            "Spanish": "ES",
            "Thai": "TH",
            "Tunisian": "TN",
            "Turkish": "TR",
            "Unknown": "US",
            "Vietnamese": "VN"
        ]
        
        return areaMapping[areaName]
    }
    
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
                
                areaResponse.meals.forEach { meal in
                    self.areaToCountryCode[meal.strArea] = self.areaNameToCountryCode(meal.strArea)
                   }
                
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
    
    func fetchCategoryList(completed: @escaping ([String]) -> Void) {
        guard let url = URL(string: categoryListURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Feil ved nettverskforespørsel: \(error?.localizedDescription ?? "Ukjent feil")")
                completed([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let categoryResponse = try decoder.decode(MealCategoryListResponse.self, from: data)
                let categoryNames = categoryResponse.meals.map {$0.strCategory}
                DispatchQueue.main.async {
                    completed(categoryNames)
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
                    SharedSearchResult(id: category.idMeal, name: category.strMeal, thumb: category.strMealThumb,description: nil, type: nil)
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
    
    func fetchIngredientList(completed: @escaping ([String]) -> Void) {
        guard let url = URL(string: ingredientListURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Feil ved nettverskforespørsel: \(error?.localizedDescription ?? "Ukjent feil")")
                completed([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let ingredientResponse = try decoder.decode(MealIngredientListResponse.self, from: data)
                let ingredientNames = ingredientResponse.meals.map { $0.strIngredient}
                DispatchQueue.main.async {
                    completed(ingredientNames)
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

//MARK: FOR TESTING

//    func fetchMealsByCategory(category: String, completion: @escaping ([FilteredCategory]) -> Void) {
//        let urlString = "\(categoryFilterURL)\(category)"
//        guard let url = URL(string: urlString) else {
//            print("Error: Ugyldig URL")
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Forespørsel til nettverk feilet: \(error?.localizedDescription ?? "Ukjent feil") ")
//                DispatchQueue.main.async {
//                    completion([])
//                }
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let filteredCategoryResponse = try decoder.decode(FilteredCategoryResponse.self, from: data)
//                DispatchQueue.main.async {
////                    let filteredAreaNames = filteredAreaResponse.meals.map { $0.strMeal }
//                    completion(filteredCategoryResponse.meals)
//                }
//            }catch {
//                print(error.localizedDescription)
//                DispatchQueue.main.async {
//                    completion([])
//                }
//            }
//        }.resume()
//    }

//    Alternativ til innhenting av data. Får ikke tak i data.

//    func getAreaList(completed: @escaping (Result<[MealArea], NMError>) -> Void) {
//        guard let url = URL(string: areaListURL) else {
//            completed(.failure(.invalidURL))
//            return
//        }
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
//            if let _ = error {
//                completed(.failure(.unableToComplete))
//                return
//            }
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(.failure(.invalidResponse))
//                return
//            }
//            guard let data = data else {
//                completed(.failure(.invalidData))
//                return
//            }
//            do {
//                let decoder = JSONDecoder()
//                let areaResponse = try decoder.decode(MealAreaResponse.self, from: data)
//                completed(.success(areaResponse.meals))
//            } catch {
//                completed(.failure(.invalidData))
//            }
//        }
//        task.resume()
//    }
