//
//  CoreDataManager.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 16/11/2023.
//

import Foundation
import CoreData
import SwiftUI

class CoreDataManager: ObservableObject {
    
//    let container = NSPersistentContainer
    
    @State var chosenArea: String = ""
    @State var areas: [AreaEntity] = []
    
    static let shared = CoreDataManager()
    let persistenceContainer: NSPersistentContainer
    
    init() {
        persistenceContainer = NSPersistentContainer(name: "Ratatouille")
        persistenceContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Database feilet med feilmelding: \(error)")
            }
        }
    }
    
    static func previewInstance() -> CoreDataManager {
        return CoreDataManager()
    }
    
    var viewContext: NSManagedObjectContext {
        persistenceContainer.viewContext
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                fatalError("Feil ved lagring: \(error)")
            }
        }
    }
    
    func saveAreasToDB(areaNames: [String]) {
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
//        isLoading = false
    }
    
    func fetchAreasFromDB() {
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
    
    func deleteAreaListFromDB() {
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
