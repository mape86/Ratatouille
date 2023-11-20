//
//  ContentView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 13/11/2023.
//

import SwiftUI
import CoreData

struct SearchView: View {
    
    @State private var searchByAreaIsOpen = false
    @State private var searchByCategoryIsOpen = false
    @State private var searchByIngredientIsOpen = false
    @State private var searchByTextIsOpen = false
    
    @State private var searchResults: [SharedSearchResult] = []

    var body: some View {
        NavigationView {
            List($searchResults) { result in
                NavigationLink(destination: RecipeDetailView(id: result.id)) {
                    HStack{
                        if let thumb = result.thumb.wrappedValue, let url = URL(string: thumb) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(10)
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .cornerRadius(10)
                        }
                        Text(result.name.wrappedValue)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Spacer()
                    Button(action: {
                        searchByAreaIsOpen.toggle()
                    }) {
                        Image(systemName: "globe.europe.africa")
                            .frame(maxHeight: 25)
                    }
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    Spacer()

                    Button(action: {
                        searchByCategoryIsOpen.toggle()
                    }) {
                        Image(systemName: "c.circle")
                            .frame(maxHeight: 25)
                    }
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    Spacer()

                    Button(action: {
                        searchByIngredientIsOpen.toggle()
                    }) {
                        Image(systemName: "carrot")
                            .frame(maxHeight: 25)
                    }
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    Spacer()

                    Button(action: {
                        searchByTextIsOpen.toggle()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .frame(maxHeight: 25)
                    }
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                }
            }
            .sheet(isPresented: $searchByAreaIsOpen) {
                SearchByAreaView(searchTerm: { results in
                    self.searchResults = results
                    self.searchByAreaIsOpen = false
                }, isPresented: $searchByAreaIsOpen)
                .presentationDetents([.large, .medium])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $searchByCategoryIsOpen) {
                SearchByCategoryView(searchTerm: { results in
                    self.searchResults = results
                    self.searchByCategoryIsOpen = false
                }, isPresented: $searchByCategoryIsOpen)
                .presentationDetents([.large, .medium])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $searchByIngredientIsOpen){
                SearchByIngredientView(searchTerm: { results in
                    self.searchResults = results
                    self.searchByIngredientIsOpen = false
                }, isPresented: $searchByIngredientIsOpen)
                .presentationDetents([.large, .medium])
                .presentationDragIndicator(.visible)
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    SearchView()
}
