//
//  SettingsView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 14/11/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage ("darkModeActive") var darkModeActive: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Redigering")) {
                    NavigationLink(destination: EditAreaView()) {
                        HStack {
                            Image(systemName: "globe.europe.africa")
                                .frame(maxHeight: 25)
                            Text("Rediger landområder")
                        }
                    }
                    
                    NavigationLink(destination: EditCategoryView()) {
                        HStack{
                            Image(systemName: "c.circle")
                                .frame(maxHeight: 25)
                            Text("Rediger kategorier")
                        }
                    }
                
                    NavigationLink(destination: EditIngredientView()) {
                        HStack{
                            Image(systemName: "carrot")
                                .frame(maxHeight: 25)
                            Text("Rediger ingredienser")
                        }
                    }
                }
                Section(header: Text("Endre Mode")) {
                    Toggle(isOn: $darkModeActive) {
                        Text(darkModeActive ? "Mørk modus" : "Lys modus")
                    }
                    .onChange(of: darkModeActive) {newValue in
                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = newValue ? .dark : .light
                    }
                }
                
                Section(header: Text("Rediger arkiv")) {
                    NavigationLink(destination: ArchiveView()) {
                        Text("Rediger arkiv")
                    }
                }
            }
            .navigationBarTitle("Innstillinger")
        }
        .onAppear{
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = darkModeActive ? .dark : .light
        }
    }
}

#Preview {
    SettingsView()
}
