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
}
