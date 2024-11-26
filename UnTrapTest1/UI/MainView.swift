//
//  ContentView.swift
//  UnTrapTest1
//
//  Created by Andrew Baratjuk on 25.11.2024.
//

import SwiftUI
import SwiftData
import DeviceActivity
import FamilyControls

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }.onAppear {
            
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: Item.self, inMemory: true)
}

extension MainView {
    @MainActor class MainViewModel: ObservableObject {
        @Published var isPresented = false
        @Published var isWaiting = false
        
        let center = AuthorizationCenter.shared
        
        init() {
            Task {
                do {
                    try await center.requestAuthorization(for: .individual
                    )
                } catch {
                    print("Failed with \(error)")
                }
            }
            
        }
        
        deinit {
            
        }
    }
}


