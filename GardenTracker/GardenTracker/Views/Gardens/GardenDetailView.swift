//
//  GardenDetailView.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

// MARK: - Garden Detail View

struct GardenDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var garden: Garden
    @State private var showingAddBed = false
    @State private var showingAddPlanting = false
    @State private var showingEditGarden = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Garden info card
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(garden.name)
                                .font(.title)
                                .bold()
                            
                            Text("\(garden.width.formatted())' × \(garden.length.formatted())'")
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            showingEditGarden = true
                        } label: {
                            Image(systemName: "pencil")
                                .padding(8)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                        }
                    }
                    
                    if let location = garden.location, !location.isEmpty {
                        Text("Location: \(location)")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    
                    if let hardinessZone = garden.hardinessZone, !hardinessZone.isEmpty {
                        Text("Hardiness Zone: \(hardinessZone)")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    
                    if let soilType = garden.soilType, !soilType.isEmpty {
                        Text("Soil Type: \(soilType)")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                
                // Garden layout
                GardenLayoutView(garden: garden)
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
                
                // Garden beds
                VStack(alignment: .leading) {
                    HStack {
                        Text("Garden Beds")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button {
                            showingAddBed = true
                        } label: {
                            Label("Add Bed", systemImage: "plus")
                                .font(.callout)
                        }
                    }
                    
                    if let beds = garden.beds, !beds.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(beds) { bed in
                                    NavigationLink(destination: GardenBedDetailView(gardenBed: bed)) {
                                        GardenBedCardView(gardenBed: bed)
                                            .frame(width: 160, height: 160)
                                    }
                                }
                            }
                        }
                    } else {
                        Text("No garden beds yet")
                            .foregroundColor(.secondary)
                            .padding(.vertical)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                
                // Plantings
                VStack(alignment: .leading) {
                    HStack {
                        Text("Plantings")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button {
                            showingAddPlanting = true
                        } label: {
                            Label("Add Planting", systemImage: "plus")
                                .font(.callout)
                        }
                    }
                    
                    if let plantings = garden.plantings, !plantings.isEmpty {
                        ForEach(plantings) { planting in
                            NavigationLink(destination: PlantingDetailView(planting: planting)) {
                                PlantingRowView(planting: planting)
                            }
                        }
                    } else {
                        Text("No plantings yet")
                            .foregroundColor(.secondary)
                            .padding(.vertical)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                
                // Tasks
                TaskListView(garden: garden)
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
            }
            .padding()
        }
        .navigationTitle("Garden Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddBed) {
            NavigationStack {
                CreateGardenBedView(garden: garden)
            }
        }
        .sheet(isPresented: $showingAddPlanting) {
            NavigationStack {
                CreatePlantingView(garden: garden)
            }
        }
        .sheet(isPresented: $showingEditGarden) {
            NavigationStack {
                EditGardenView(garden: garden)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Garden.self, configurations: config)
    
    let garden = Garden(
        name: "Sample Garden",
        width: 20.0,
        length: 30.0,
        location: "Backyard",
        soilType: "Loam",
        hardinessZone: "7b"
    )
    
    return NavigationStack {
        GardenDetailView(garden: garden)
            .modelContainer(container)
    }
}
