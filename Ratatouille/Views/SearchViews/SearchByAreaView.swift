//
//  SearchByAreaView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 16/11/2023.
//

import SwiftUI

struct SearchByAreaView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var searchTerm: ([String]) -> Void
    @ObservedObject var networkManager = NetworkManager.shared
    @State private var areaList: [String] = []
    @State private var chosenArea: String = ""
    
    @Binding var isPresented: Bool
    
    
    var body: some View {
        VStack {
            Text("Søk område")
                .font(.title.bold())
                .foregroundStyle(LinearGradient(colors: [.pink, .purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding()
            CustomLoadButton(title: "Last inn områder") {
                          networkManager.fetchAreaList{
                              if let firstArea = networkManager.areas.first {
                                  chosenArea = firstArea.strArea
                              }
                          }

            }
            if !networkManager.areas.isEmpty {
                Picker("Velg område å søke fra", selection: $chosenArea) {
                    ForEach(networkManager.areas, id: \.id) {area in
                        Text(area.strArea).tag(area.strArea)
                    }
                }
            }
//            .onAppear{
//                networkManager.fetchAreaList()
//            }
           
        }
        
        Button("Søk") {
            let results = ["Test område 1", "test område 2"]
            searchTerm(results)
            isPresented = false
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.gray.opacity(0.5)))
    }
}

#Preview {
    SearchByAreaView(
        searchTerm: { _ in print("Søket er utført")},
        isPresented: .constant(true)
    )
}
