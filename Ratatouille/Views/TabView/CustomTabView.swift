//
//  TabView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 14/11/2023.
//

import SwiftUI

struct CustomTabView: View {
    
    @State private var tabColor: Color!
    @State private var selectedTabIndex = 0
    
    //    init() {
    //        self.tabColor = tabColors[0]
    //    }
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            MyRecipesView()
                .tabItem {
                    Label("Mine Oppskrifter", systemImage: "fork.knife")
                }
                .tag(0)
            SearchView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .tabItem {
                    Label("Søk", systemImage: "magnifyingglass")
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    Label("Innstillinger", systemImage: "gear")
                }
                .tag(2)
        }
        .accentColor(tabColors[selectedTabIndex])
    }
}

fileprivate
let tabColors = [
    Color(hue: 0.910, saturation: 0.80, brightness: 0.90),
    Color(hue: 0.790, saturation: 0.80, brightness: 0.90),
    Color(hue: 0.710, saturation: 0.80, brightness: 0.90),
]

#Preview {
    CustomTabView()
}
