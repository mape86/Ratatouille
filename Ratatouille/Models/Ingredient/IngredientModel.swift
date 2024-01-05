//
//  IngredientModel.swift
//  Ratatouille
//

import Foundation

struct MealIngredientList: Decodable, Hashable, Identifiable {
    
    let strIngredient: String
    var id: String {strIngredient}
}

struct MealIngredient: Decodable, Hashable, Identifiable {
    
    let idIngredient: String
    let strIngredient: String
    let strDescription: String?
    let strType: String?
    
    var id: String {idIngredient}
}

struct filteredIngredient: Decodable, Hashable, Identifiable {
    
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    var id: String {idMeal}
}

struct MealIngredientResponse: Decodable {
    
    let meals: [MealIngredient]
    
}

struct FilteredIngredientResponse: Decodable {
    
    let meals: [filteredIngredient]
    
}

struct MealIngredientListResponse: Decodable {
    
    let meals: [MealIngredientList]
    
}
