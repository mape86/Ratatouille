//
//  IngredientModel.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 15/11/2023.
//

import Foundation

struct MealIngredient: Decodable {
    
    let idIngredient: String
    let strIngredient: String
    let strDescription: String?
    let strType: String?
    
}

struct MealIngredientResponse: Decodable {
    
    let ingredients: [MealIngredient]
    
}
