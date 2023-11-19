//
//  SearchViewModel.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 19/11/2023.
//

import Foundation
import CoreData

class SearchViewModel: ObservableObject {
    
    private let coreDataManager: CoreDataManager
    
    @Published var areas: [AreaEntity] = []
    @Published var isLoading = false
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchAreasFromDB() {
        isLoading = true
        let fetchRequest: NSFetchRequest<AreaEntity> = AreaEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "areaName", ascending: true)]
        
        do {
            areas = try coreDataManager.persistenceContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Feilet ved henting av områder fra DB. \(error)")
        }
        isLoading = false
    }
    
    func saveAreasToDB(areaNames: [String]) {
        let context = coreDataManager.persistenceContainer.viewContext
        areaNames.forEach {areaName in
            let newArea = AreaEntity(context: context)
            newArea.areaName = areaName
        }
        
        coreDataManager.saveContext()
        fetchAreasFromDB()
    }
    
    func deleteAreaListFromDB() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AreaEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coreDataManager.persistenceContainer.viewContext.execute(deleteRequest)
            areas.removeAll()
        } catch {
            print("Feilet ved sletting av områder fra databasen. \(error)")
        }
    }
}
