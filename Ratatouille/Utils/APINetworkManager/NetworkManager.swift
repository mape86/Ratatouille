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
    @Published var areas: [MealArea] = []
    @Published var categories: [MealCategoryList] = []
    @Published var ingredientsList: [MealIngredientList] = []
    
    //MARK: Area URLS
    //List of all areas
    private let areaListURL = "https://www.themealdb.com/api/json/v1/1/list.php?a=list"
    
    //MARK: Category URLS
    //List of all categories
    private let categoryListURL = "https://www.themealdb.com/api/json/v1/1/list.php?c=list"
    //Filter by category
    private let categoryFilterURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
    
    //MARK: Ingredient URLS
    //List of all ingredients
    private let ingredientListURL = "https://www.themealdb.com/api/json/v1/1/list.php?i=list"
    
    private init () {}
    
    //MARK: Area Functions
    
    func fetchAreaList(completion: @escaping () -> Void) {
        guard let url = URL(string: areaListURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {return}
            
            do {
                let decoder = JSONDecoder()
                let areaResponse = try decoder.decode(MealAreaResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.areas = areaResponse.meals
                    completion()
                }
            }catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    //MARK: Category Functions
    
    func fetchCategoryList(completion: @escaping () -> Void) {
        guard let url = URL(string: categoryListURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {return}
            
            do {
                let decoder = JSONDecoder()
                let categoryResponse = try decoder.decode(MealCategoryListResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.categories = categoryResponse.meals
                    completion()
                }
            }catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    //MARK: Ingredient Functions
    
    func fetchIngredientList(completion: @escaping () -> Void) {
        guard let url = URL(string: ingredientListURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {return}
            
            do {
                let decoder = JSONDecoder()
                let ingredientResponse = try decoder.decode(MealIngredientListResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.ingredientsList = ingredientResponse.meals
                    completion()
                }
            }catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}



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
