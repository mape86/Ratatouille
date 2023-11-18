//
//  CoreDataManager.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 16/11/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let persistenceContainer: NSPersistentContainer
    
    private init() {
        persistenceContainer = NSPersistentContainer(name: "Ratatouille")
        persistenceContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Database feilet med feilmelding: \(error)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        persistenceContainer.viewContext
    }
    
    func saveAreasToDB(areaNames: [String], completed: @escaping (Error?) -> Void) {
        areaNames.forEach { areaName in
            let area = AreaEntity(context: viewContext)
            area.areaName = areaName
        }
        
        do{
            try viewContext.save()
            completed(nil)
        } catch {
            completed(error)
        }
    }
    
    func fetchAreasFromDB(completed: @escaping (Result<[AreaEntity], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<AreaEntity> = AreaEntity.fetchRequest()
        do {
            let areas = try viewContext.fetch(fetchRequest)
            completed(.success(areas))
        } catch {
            completed(.failure(error))
        }
    }
    
    func deleteAllAreasFromDB(completed: @escaping (Error?) -> Void) {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = AreaEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
            completed(nil)
        } catch {
            completed(error)
        }
    }
    
}
