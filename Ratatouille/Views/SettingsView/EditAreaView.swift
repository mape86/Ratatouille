//
//  AreaView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 20/11/2023.
//

import SwiftUI
import CoreData

struct EditAreaView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: AreaEntity.entity(),
        sortDescriptors: []
    ) var areas: FetchedResults<AreaEntity>
    
    @ObservedObject var networkManager = NetworkManager.shared
    @State var isLoading: Bool = false
    @State private var isPresented = false
    @State private var isShowingAlert = false
    
    func areaNameToCountryCode(_ areaName: String) -> String? {
        
        let areaMapping = [
            // In API:
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
            
            //Not in API:
            
        ]
        
        return areaMapping[areaName]
    }
    
    //MARK: Main View
    
    var body: some View {
        NavigationView {
            List{
                Button("Legg til område") {
                    isPresented = true
                }
                ForEach(areas, id: \.self) { area in
                    if area.isSaved == true {
                        HStack {
                            Text(area.areaName ?? "Ukjent område")
                            
                            Spacer()
                            
                            if let countryCode = areaNameToCountryCode(area.areaName ?? "Unknown"), let url = URL(string: "https://www.flagsapi.com/\(countryCode)/flat/64.png") {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 46, height: 46)
                                        .cornerRadius(10)
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 46, height: 46)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Rediger områder")
           
        }
        .onAppear{
            if self.areas.isEmpty {
                loadAreasFromAPI()
            }
        }
    }
    
    //MARK: Functions
    
    private func loadAreasFromAPI() {
        isLoading = true
        networkManager.fetchAreaList { areaNames in
            saveAreasToDB(areaNames: areaNames)
        }
    }
    
    private func saveAreasToDB(areaNames: [String]) {
        areaNames.forEach { areaName in
            let newArea = AreaEntity(context: viewContext)
            newArea.areaName = areaName
            newArea.isSaved = true
        }
        do {
            
            try viewContext.save()
            
        } catch {
            print("Feilet ved lagring til databasen. \(error)")
        }
        isLoading = false
    }
}

#Preview {
    EditAreaView()
}
