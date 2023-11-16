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

struct MealAreaResponse: Codable {
    
    let meals: [MealArea]
    
}


