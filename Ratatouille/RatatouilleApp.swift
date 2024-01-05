//
//  RatatouilleApp.swift
//  Ratatouille
//

import SwiftUI

@main
struct RatatouilleApp: App {
    
    @AppStorage ("darkModeActive") private var darkModeActive = false

    let coreDataManager = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environment(\.managedObjectContext, coreDataManager.viewContext)
                .preferredColorScheme(darkModeActive ? .dark : .light)
        }
    }
}
