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
    
    @StateObject var convertFlag: FlagConvert = FlagConvert()
    @ObservedObject var coreDataManager: CoreDataManager = CoreDataManager.shared
    @ObservedObject var networkManager = NetworkManager.shared
    @State var isLoading: Bool = false
    @State private var activeAlert: ActiveAlert?
    @State private var itemToArchive: AreaEntity?
    @State private var addNewAreaName: String = ""
        
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
                            
                            if let url = URL(string: "https://www.flagsapi.com/\(area.countryCode ?? "")/flat/64.png") {
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
            let countryCode = convertFlag.areaNameToCountryCode(areaName)
            newArea.countryCode = countryCode
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
        let countryCode = convertFlag.areaNameToCountryCode(newArea.areaName ?? "")
        newArea.countryCode = countryCode
        
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
