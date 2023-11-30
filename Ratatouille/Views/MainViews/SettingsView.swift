//
//  SettingsView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 14/11/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage ("darkModeActive") private var darkModeActive = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Redigering")) {
                    NavigationLink(destination: SettingsAreaListView()) {
                        HStack {
                            Image(systemName: "globe.europe.africa")
                                .frame(maxHeight: 25)
                            Text("Rediger landområder")
                        }
                    }
                    
                    NavigationLink(destination: SettingsCategoryListView()) {
                        HStack{
                            Image(systemName: "c.circle")
                                .frame(maxHeight: 25)
                            Text("Rediger kategorier")
                        }
                    }
                
                    NavigationLink(destination: SettingsIngredientListView()) {
                        HStack{
                            Image(systemName: "carrot")
                                .frame(maxHeight: 25)
                            Text("Rediger ingredienser")
                        }
                    }
                }
                Section(header: Text("Endre Mode")) {
                    Toggle("Mørk Modus", isOn: $darkModeActive)
                }
                
                Section(header: Text("Rediger arkiv")) {
                    NavigationLink(destination: ArchiveView()) {
                        Text("Rediger arkiv")
                    }
                }
            }
            .navigationBarTitle("Innstillinger")
        }
    }
}

#Preview {
    SettingsView()
}
