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
    
    var searchTerm: ([SharedSearchResult]) -> Void

    @StateObject var convertFlag: FlagConvert = FlagConvert()
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
            
            HStack {
                
                Spacer()
                
                VStack {
                    CustomLoadButton(title: "last inn") {
                        if areas.isEmpty {
                            loadAreasFromAPI()
                        } else {
                            print("Allerede lastet inn")
                        }
                    }
                    Text("fra API")
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
                            message: Text("Du er i ferd med å slette hele listen fra databasen, dette gjelder også områder du har lagt til din liste. Vil du fortsette?"),
                            primaryButton: .destructive(Text("Slett")) {
                                deleteAreaListFromDB()
                            },
                            secondaryButton: .cancel(Text("Avbryt"))
                        )
                    }
                    Text("fra database")
                        .font(.callout)
                }
                
                Spacer()
            }
        }
        .onAppear{
            fetchAreasFromDB()
        }
        
        Spacer()
        
        VStack {
            CustomLoadButton(title: "Søk") {
                networkManager.fetchMealsByArea(area: chosenArea) { mealName in
                    searchTerm(mealName)
                    isPresented = false
                }
            }
            if isLoading {
                ProgressView("Laster inn områder...")
            } else {
                HStack {
                    Picker("Velg område", selection: $chosenArea) {
                        ForEach(areas, id: \.self) {area in
                            if area.isSaved == true {
                                Text(area.areaName ?? "").tag(area.areaName ?? "")
                            }
                        }
                    }
                }
            }
        }
        
        Spacer()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(.gray.opacity(0.5)))
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
            newArea.isSaved = true
            let countryCode = convertFlag.areaNameToCountryCode(areaName)
            newArea.countryCode = countryCode
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
