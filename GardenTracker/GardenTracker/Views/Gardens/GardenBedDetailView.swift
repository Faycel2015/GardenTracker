//
//  GardenBedDetailView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

// MARK: - Garden Bed Detail View

struct GardenBedDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var gardenBed: GardenBed
    @State private var showingAddPlanting = false
    @State private var showingEditBed = false
    @State private var showingCropRotation = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Bed info card
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(gardenBed.name)
                                .font(.title)
                                .bold()
                            
                            Text("\(gardenBed.width.formatted())' × \(gardenBed.length.formatted())'")
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            showingEditBed = true
                        } label: {
                            Image(systemName: "pencil")
                                .padding(8)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                        }
                    }
                    
                    if let soilType = gardenBed.soilType, !soilType.isEmpty {
                        Text("Soil Type: \(soilType)")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    
                    if let garden = gardenBed.garden {
                        Text("Part of: \(garden.name)")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                
                // Bed layout
                GardenBedLayoutView(gardenBed: gardenBed)
                    .frame(height: 300)
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
                    
                    if let plantings = gardenBed.plantings, !plantings.isEmpty {
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
                
                // Crop Rotation
                VStack(alignment: .leading) {
                    HStack {
                        Text("Crop Rotation History")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button {
                            showingCropRotation = true
                        } label: {
                            Label("Add Entry", systemImage: "plus")
                                .font(.callout)
                        }
                    }
                    
                    if let rotation = gardenBed.cropRotationHistory, !rotation.isEmpty {
                        let sortedRotation = rotation.sorted {
                            if $0.year != $1.year {
                                return $0.year > $1.year
                            } else {
                                return $0.season.rawValue > $1.season.rawValue
                            }
                        }
                        
                        ForEach(sortedRotation) { entry in
                            HStack {
                                Text("\(entry.year) - \(entry.season.rawValue)")
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Text(entry.cropFamily)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    } else {
                        Text("No crop rotation history yet")
                            .foregroundColor(.secondary)
                            .padding(.vertical)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
            }
            .padding()
        }
        .navigationTitle("Garden Bed")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddPlanting) {
            NavigationStack {
                CreatePlantingView(gardenBed: gardenBed)
            }
        }
        .sheet(isPresented: $showingEditBed) {
            NavigationStack {
                EditGardenBedView(gardenBed: gardenBed)
            }
        }
        .sheet(isPresented: $showingCropRotation) {
            NavigationStack {
                AddCropRotationView(gardenBed: gardenBed)
            }
        }
    }
}

// MARK: - Garden Bed Layout View

struct GardenBedLayoutView: View {
    let gardenBed: GardenBed
    
    var body: some View {
        ZStack {
            // Bed background
            Rectangle()
                .fill(Color.brown.opacity(0.6))
            
            // Grid lines
            GridView(width: gardenBed.width, length: gardenBed.length, gridSize: 0.5)
            
            // Plantings
            if let plantings = gardenBed.plantings {
                ForEach(plantings) { planting in
                    PlantingCircleView(planting: planting, bedWidth: gardenBed.width, bedLength: gardenBed.length)
                }
            }
        }
    }
}

// MARK: - Grid View

struct GridView: View {
    let width: Double
    let length: Double
    let gridSize: Double
    
    var body: some View {
        ZStack {
            // Vertical lines
            ForEach(0..<Int(width / gridSize) + 1, id: \.self) { i in
                let x = (Double(i) * gridSize / width) * 2 - 1
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 1)
                    .position(x: x * (UIScreen.main.bounds.width / 2), y: 0)
                    .frame(width: 1, height: UIScreen.main.bounds.height)
            }
            
            // Horizontal lines
            ForEach(0..<Int(length / gridSize) + 1, id: \.self) { i in
                let y = (Double(i) * gridSize / length) * 2 - 1
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
                    .position(x: 0, y: y * (UIScreen.main.bounds.height / 2))
                    .frame(width: UIScreen.main.bounds.width, height: 1)
            }
        }
    }
}

// MARK: - Planting Circle View

struct PlantingCircleView: View {
    let planting: Planting
    let bedWidth: Double
    let bedLength: Double
    
    var body: some View {
        let relativeX = (planting.xPosition / bedWidth) * 2 - 1
        let relativeY = (planting.yPosition / bedLength) * 2 - 1
        let radius = calculateRadius()
        
        ZStack {
            Circle()
                .fill(plantingColor)
                .frame(width: radius * 2, height: radius * 2)
                .position(
                    x: relativeX * (UIScreen.main.bounds.width / 2),
                    y: relativeY * (UIScreen.main.bounds.height / 2)
                )
            
            Text(planting.plant?.name ?? "")
                .font(.system(size: 8))
                .foregroundColor(.white)
                .position(
                    x: relativeX * (UIScreen.main.bounds.width / 2),
                    y: relativeY * (UIScreen.main.bounds.height / 2)
                )
        }
    }
    
    private func calculateRadius() -> Double {
        // Base the radius on the plant spacing if available
        if let plant = planting.plant {
            // Convert spacing from inches to feet, then to relative screen units
            let spacingInFeet = plant.spacing / 12
            let relativeSpacing = (spacingInFeet / bedWidth) * UIScreen.main.bounds.width / 2
            return relativeSpacing
        }
        
        // Default radius if plant is not available
        return 15
    }
    
    private var plantingColor: Color {
        switch planting.status {
        case .planned:
            return .gray.opacity(0.6)
        case .active:
            return .green.opacity(0.7)
        case .harvested:
            return .orange.opacity(0.7)
        case .failed:
            return .red.opacity(0.7)
        case .removed:
            return .black.opacity(0.5)
        }
    }
}

#Preview {
    GardenBedDetailView(gardenBed: GardenBed(
        name: "Raised Bed 1",
        width: 4.0,
        length: 8.0,
        xPosition: 0.0,
        yPosition: 0.0
    ))
}
