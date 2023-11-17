//
//  AreaModel.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 15/11/2023.
//

import Foundation

struct MealArea: Codable, Hashable, Identifiable {
    
    let strArea: String
    var id: String {strArea}
}

struct FilteredArea: Codable, Hashable, Identifiable {
    
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    var id: String {idMeal}
}

struct FilteredAreaResponse: Codable {
    
    let meals: [FilteredArea]
    
}

struct MealAreaResponse: Codable {
    
    let meals: [MealArea]
    
}

extension FilteredArea {
    func toSharedSearchResult() -> SharedSearchResult {
        SharedSearchResult(id: idMeal, name: strMeal, thumb: strMealThumb, description: nil)
    }
}


