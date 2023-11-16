//
//  IngredientModel.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 15/11/2023.
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

struct MealIngredientResponse: Decodable {
    
    let meals: [MealIngredient]
    
}

struct MealIngredientListResponse: Decodable {
    
    let meals: [MealIngredientList]
    
}
