//
//  CategoryModel.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 15/11/2023.
//

import Foundation

struct MealCategoryList: Codable, Hashable, Identifiable {
    
    let strCategory: String
    var id: String {strCategory}
    
}

struct FilteredCategory: Codable, Hashable, Identifiable {
    
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    var id: String {idMeal}
    
}

struct MealCategory: Codable, Hashable, Identifiable {
    
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
    
    var id: String {idCategory}
    
}

struct MealCategoryListResponse: Codable {
    
    let meals: [MealCategoryList]
    
}

struct FilteredCategoryResponse: Codable {
    
    let meals: [FilteredCategory]
    
}

struct MealCategoryResponse: Codable {
    
    let categories: [MealCategory]
    
}
