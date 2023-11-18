//
//  RatatouilleApp.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 13/11/2023.
//

import SwiftUI

@main
struct RatatouilleApp: App {

    let coreDataManager = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environment(\.managedObjectContext, coreDataManager.viewContext)
        }
    }
}
