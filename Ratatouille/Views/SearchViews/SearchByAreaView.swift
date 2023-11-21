//
//  SearchByAreaView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 16/11/2023.
//

import SwiftUI
import CoreData

//MARK: Main View

struct SearchByAreaView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
//    @StateObject var coreDataManager = CoreDataManager
    
    var searchTerm: ([SharedSearchResult]) -> Void
//    var flagUrl: ([SharedSearchResult]) -> Void
    @ObservedObject var networkManager = NetworkManager.shared
    @State private var chosenArea: String = ""
    @State private var areas: [AreaEntity] = []
    @State var isLoading: Bool = false
    @State private var isShowingAlert = false
    
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text("Søk område")
                .font(.title.bold())
                .foregroundStyle(LinearGradient(colors: [.customPurpleDark, .customPurpleMedium], startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
    
            if isLoading {
                ProgressView("Laster inn områder...")
            } else {
                Picker("Velg område", selection: $chosenArea) {
                    ForEach(areas, id: \.self) {area in
                        Text(area.areaName ?? "").tag(area.areaName ?? "")
                    }
                }
            }
            HStack {
                Spacer()
                VStack {
                    CustomLoadButton(title: "last inn") {
                        loadAreasFromAPI()
                    }
                    Text("Last inn fra API")
                        .font(.callout)
                }
                Spacer()
                VStack{
                    CustomLoadButton(title: "Slett") {
                        self.isShowingAlert = true
                    }
                    .alert(isPresented: $isShowingAlert) {
                        Alert(
                            title: Text("Advarsel"),
                            message: Text("Du er i ferd med å slette hele listen fra databasen. Vil du fortsette?"),
                            primaryButton: .destructive(Text("Slett")) {
                                deleteAreaListFromDB()
                            },
                            secondaryButton: .cancel(Text("Avbryt"))
                        )
                    }
                    Text("Slett fra database")
                }
                Spacer()
            }
        }
        .onAppear{
            fetchAreasFromDB()
        }
        
        CustomLoadButton(title: "Søk") {
            networkManager.fetchMealsByArea(area: chosenArea) { mealName in
                searchTerm(mealName)
                isPresented = false
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.gray.opacity(0.5)))
    }
    
    //MARK: - Functions
    
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
        }
        do {
            try viewContext.save()
            fetchAreasFromDB()
        } catch {
            print("Feilet ved lagring til databasen. \(error)")
        }
        isLoading = false
    }
    
    private func fetchAreasFromDB() {
        let fetchRequest: NSFetchRequest<AreaEntity> = AreaEntity.fetchRequest()
        
        do {
            areas = try viewContext.fetch(fetchRequest)
            if let firstArea = areas.first {
                chosenArea = firstArea.areaName ?? ""
            }
        }catch {
            print("Feilet ved henting av områder fra DB. \(error)")
        }
    }
    
    private func deleteAreaListFromDB() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AreaEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
            areas = []
            chosenArea = ""
        } catch {
            print("Feilet ved sletting av områder fra databasen. \(error)")
        }
    }
}

#Preview {
    SearchByAreaView(
        searchTerm: { _ in print("Søket er utført")},
        isPresented: .constant(true)
    )
    
}
//View {
//    VStack {
//        Text("Søk område")
//            .font(.title.bold())
//            .foregroundStyle(LinearGradient(colors: [.pink, .purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
//            .padding()
//        CustomLoadButton(title: "Last inn områder") {
//                      networkManager.fetchAreaList{
//                          if let firstArea = networkManager.areas.first {
//                              chosenArea = firstArea.strArea
//                          }
//                      }
//
//        }
//        if !networkManager.areas.isEmpty {
//            Picker("Velg område å søke fra", selection: $chosenArea) {
//                ForEach(networkManager.areas, id: \.id) {area in
//                    Text(area.strArea).tag(area.strArea)
//                }
//            }
//        }
//
//    }
//    .onAppear{
//        networkManager.fetchAreaList{
//            if let firstArea = networkManager.areas.first {
//                chosenArea = firstArea.strArea
//            }
//        }
//    }
//
//    Button("Søk") {
//        networkManager.fetchMealsByArea(area: chosenArea) { mealName in
//            searchTerm(mealName)
//            isPresented = false
//        }
//    }
//    .frame(maxWidth: .infinity, maxHeight: .infinity)
//    .background(Color(.gray.opacity(0.5)))
//}


// ALTERNATE FUNCTIONS

//    private func loadAreasFromDB() {
//        CoreDataManager.shared.fetchAreasFromDB { result in
//            switch result {
//            case .success(let areas):
//                self.areas = areas
//                if let firstArea = areas.first {
//                    chosenArea = firstArea.areaName ?? ""
//                }
//            case .failure(let error):
//                print("Feilet ved henting av områder fra DB. \(error)")
//            }
//
//        }
//        //        if areas.isEmpty {
//        //            networkManager.fetchAreaList {
//        //                for area in networkManager.areas {
//        //                    let newArea = AreaEntity(context: managedObjectContext)
//        //                    newArea.areaName = area.strArea
//        //
//        //                    do {
//        //                        try managedObjectContext.save()
//        //                    } catch {
//        //                        print("Feilet ved lagring til context. \(error)")
//        //                    }
//        //                }
//        //                chosenArea = networkManager.areas.first?.strArea ?? ""
//        //            }
//        //        } else {
//        //            chosenArea = areas.first?.areaName ?? ""
//        //        }
//    }


// Alternate button, for loading directly from API.

//            CustomLoadButton(title: "Last inn områder") {
//                networkManager.fetchAreaList{_ in
//                              if let firstArea = networkManager.areas.first {
//                                  chosenArea = firstArea.strArea
//                              }
//                          }
//
//            }
