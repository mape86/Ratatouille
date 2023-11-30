//
//  FlagConvert.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 30/11/2023.
//

import Foundation

final class FlagConvert: ObservableObject {
    
    func areaNameToCountryCode(_ areaName: String) -> String? {
        
        let areaMapping = [
            // Areas in API:
            "American": "US",
            "British": "GB",
            "Canadian": "CA",
            "Chinese": "CN",
            "Dutch": "NL",
            "Egyptian": "EG",
            "Filipino" : "PH",
            "French": "FR",
            "Greek": "GR",
            "Indian": "IN",
            "Irish": "IE",
            "Italian": "IT",
            "Jamaican": "JM",
            "Japanese": "JP",
            "Kenyan": "KE",
            "Malaysian": "MY",
            "Mexican": "MX",
            "Moroccan": "MA",
            "Polish": "PL",
            "Portuguese": "PT",
            "Russian": "RU",
            "Spanish": "ES",
            "Thai": "TH",
            "Tunisian": "TN",
            "Turkish": "TR",
            "Vietnamese": "VN",
            
            //Areas not in API:
            "Austraila": "AU",
            "Argentina": "AR",
            "Denmark": "DK",
            "Danish": "DK",
            "Danmark": "DK",
            "Dansk": "DK",
            "Finland": "FI",
            "Finnish": "FI",
            "Nordic": "NO",
            "Norge": "NO",
            "Norsk": "NO",
            "Norway": "NO",
            "Norwegian": "NO",
            "Sweden": "SE",
            "Swedish": "SE",
            "Sverige": "SE",
            
            
        ]
        
        return areaMapping[areaName]
    }
    
}
