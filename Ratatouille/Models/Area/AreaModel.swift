//
//  AreaModel.swift
//  Ratatouille
//

import Foundation

struct MealAreaList: Codable, Hashable, Identifiable {
    
    let strArea: String
    var id: String {strArea}
}

struct MealArea: Codable, Hashable, Identifiable {
    
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    var id: String {idMeal}
}

struct MealAreaResponse: Codable {
    
    let meals: [MealArea]
    
}

struct MealAreaListResponse: Codable {
    
    let meals: [MealAreaList]
    
}



