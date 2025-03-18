//
//  PlantsView.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

struct PlantsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var plants: [Plant]
    @State private var searchText = ""
    @State private var showingAddPlant = false
    @State private var filterType: String? = nil
    
    var filteredPlants: [Plant] {
        if searchText.isEmpty && filterType == nil {
            return plants
        }
        
        return plants.filter { plant in
            let matchesSearch = searchText.isEmpty ||
                plant.name.localizedCaseInsensitiveContains(searchText) ||
                plant.type.localizedCaseInsensitiveContains(searchText)
            
            let matchesFilter = filterType == nil || plant.type == filterType
            
            return matchesSearch && matchesFilter
        }
    }
    
    var plantTypes: [String] {
        let types = Set(plants.map { $0.type })
        return Array(types).sorted()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Filter pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        FilterPill(title: "All", isSelected: filterType == nil) {
                            filterType = nil
                        }
                        
                        ForEach(plantTypes, id: \.self) { type in
                            FilterPill(title: type, isSelected: filterType == type) {
                                filterType = type
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                List {
                    if filteredPlants.isEmpty {
                        ContentUnavailableView(
                            "No Plants Found",
                            systemImage: "leaf.fill",
                            description: Text(searchText.isEmpty ? "Tap the + button to add your first plant" : "Try a different search term")
                        )
                    } else {
                        ForEach(filteredPlants) { plant in
                            NavigationLink(destination: PlantDetailView(plant: plant)) {
                                PlantRowView(plant: plant)
                            }
                        }
                        .onDelete(perform: deletePlants)
                    }
                }
                .searchable(text: $searchText, prompt: "Search plants")
            }
            .navigationTitle("Plants")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddPlant = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPlant) {
                NavigationStack {
                    AddPlantView()
                }
            }
        }
    }
    
    private func deletePlants(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredPlants[index])
        }
    }
}

#Preview {
    PlantsView()
}
