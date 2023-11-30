//
//  AreaView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 20/11/2023.
//

import SwiftUI
import CoreData

enum ActiveAlert: Identifiable {
    case showUserAlert, showEmptyFieldAlert
    
    var id: Int {
        hashValue
    }
}

struct SettingsAreaListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: AreaEntity.entity(),
        sortDescriptors: []
    ) var areas: FetchedResults<AreaEntity>
    
    @ObservedObject var networkManager = NetworkManager.shared
    @State var isLoading: Bool = false
    @State private var activeAlert: ActiveAlert?
    @State private var itemToArchive: AreaEntity?
    @State private var addNewAreaName: String = ""
    
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
    
    //MARK: Main View
    
    var body: some View {
        
        List{
            HStack {
                TextEditor(text: $addNewAreaName)
                    .tint(.colorPurpleDark)
                    .border(Color.colorPurpleDark, width: 1)
                Button("Legg til") {
                    addAreaToDB()
                    
                }
            }
            ForEach(areas, id: \.self) { area in
                if area.isSaved == true {
                    NavigationLink(destination: EditAreaView(area: area)) {
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
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                itemToArchive = area
                                showUserAlert()
                            } label: {
                                Label("Arkiver", systemImage: "archivebox")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Områder")
        .onAppear{
            if self.areas.isEmpty {
                loadAreasFromAPI()
            }
        }
        .alert(item: $activeAlert) { alert in
            switch alert {
            case .showEmptyFieldAlert:
                return Alert(
                    title: Text("Tomt felt"),
                    message: Text("Du må skrive inn et navn på kategorien du vil legge til"),
                    dismissButton: .default(Text("OK"))
                )
                
            case .showUserAlert:
                return Alert(
                    title: Text("Arkivere Kategorien"),
                    message: Text("Er du sikke på at du vil sende denne kategorien til arkivet?"),
                    primaryButton: .default(Text("Avbryt")),
                    secondaryButton: .destructive(Text("Arkiver"), action: sendToArchive)
                )
            }
        }
    }
    
    //MARK: Functions
    
    func showUserAlert() {
        self.activeAlert = .showUserAlert
    }
    
    func showEmptyFieldAlert() {
        self.activeAlert = .showEmptyFieldAlert
    }
    
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
    
    private func addAreaToDB() {
        guard !addNewAreaName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            
            showEmptyFieldAlert()
            return
        }
        
        let newArea = AreaEntity(context: viewContext)
        newArea.areaName = addNewAreaName
        newArea.isSaved = true
        
        do {
            try viewContext.save()
        } catch {
            print("Feilet ved lagring til databasen. \(error)")
        }
        addNewAreaName = ""
    }
    
    private func sendToArchive() {
        if let areaItemToArchive = itemToArchive {
            areaItemToArchive.isSaved = false
            try? viewContext.save()
        }
    }
}

#Preview {
    SettingsAreaListView()
}
