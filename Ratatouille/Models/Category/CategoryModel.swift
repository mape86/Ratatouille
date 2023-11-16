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

struct MealCategoryResponse: Codable {
    
    let meals: [MealCategory]
    
}
