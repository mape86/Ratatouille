//
//  MealModel.swift
//  Ratatouille
//

import Foundation

struct Meal: Decodable {
    
    let idMeal: String
    let strMeal: String
    let strDrinkAlternate: String?
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strTags: String?
    let strYoutube: String?
    
    enum CodingKeys: CodingKey {
        case idMeal
        case strMeal
        case strDrinkAlternate
        case strCategory
        case strArea
        case strInstructions
        case strMealThumb
        case strTags
        case strYoutube
    }
    
}

struct MealResponse: Decodable {
    
    let meals: [Meal]
    
}

struct SharedSearchResult: Identifiable {
    let id: String
    var name: String
    var thumb: String?
    var flagThumb: String?
    var countryCode: String?
    var description: String?
    var type: String?
}
