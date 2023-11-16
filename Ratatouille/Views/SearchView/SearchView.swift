//
//  ContentView.swift
//  Ratatouille
//
//  Created by Marius Pettersen on 13/11/2023.
//

import SwiftUI
import CoreData

struct SearchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var searchByAreaIsOpen = false
    @State private var searchByCategoryIsOpen = false
    @State private var searchByIngredientIsOpen = false
    @State private var searchByTextIsOpen = false
    
    @State private var searchResults: [String] = []

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        searchByAreaIsOpen.toggle()
                    }) {
                        Image(systemName: "globe.europe.africa")
                    }

                    Button(action: {
                        searchByCategoryIsOpen.toggle()
                    }) {
                        Image(systemName: "c.circle")
                    }

                    Button(action: {
                        searchByIngredientIsOpen.toggle()
                    }) {
                        Image(systemName: "carrot")
                    }

                    Button(action: {
                        searchByTextIsOpen.toggle()
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .sheet(isPresented: $searchByAreaIsOpen) {
                SearchByAreaView(searchTerm: { results in
                    self.searchResults = results},
                                 isPresented: $searchByAreaIsOpen)
            }
            .sheet(isPresented: $searchByCategoryIsOpen) {
                SearchByCategoryView(searchTerm: { results in
                    self.searchResults = results},
                                     isPresented: $searchByCategoryIsOpen)
            }
            .sheet(isPresented: $searchByIngredientIsOpen) {
              
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
