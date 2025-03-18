//
//  PlantingDetailView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct PlantingDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var planting: Planting
    @State private var showingAddHarvest = false
    @State private var showingEditPlanting = false
    @State private var showingAddGrowthLog = false
    
    var growthPercentage: Double {
        guard let plant = planting.plant else { return 0 }
        return Date().growthProgressPercentage(
            plantingDate: planting.datePlanted,
            daysToMaturity: plant.daysToMaturity
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Planting info card
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            if let plant = planting.plant {
                                Text(plant.name)
                                    .font(.title)
                                    .bold()
                                
                                Text(plant.type)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Unknown Plant")
                                    .font(.title)
                                    .bold()
                            }
                        }
                        ProgressView(value: growthPercentage, total: 100)
                            .progressViewStyle(.linear)
                        
                        Spacer()
                        
                        Button {
                            showingEditPlanting = true
                        } label: {
                            Image(systemName: "pencil")
                                .padding(8)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                        }
                    }
                    
                    HStack {
                        StatusBadge(status: planting.status)
                        
                        Text("Quantity: \(planting.quantity)")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray5))
                            .clipShape(Capsule())
                    }
                    .padding(.top, 4)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Date Planted")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(planting.datePlanted.formatted(date: .abbreviated, time: .omitted))
                                .font(.body)
                        }
                        
                        Spacer()
                        
                        if let harvestDate = planting.expectedHarvestDate {
                            VStack(alignment: .trailing) {
                                Text("Expected Harvest")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(harvestDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(.body)
                            }
                        }
                    }
                    
                    if let plant = planting.plant, let harvestDate = planting.expectedHarvestDate {
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.day], from: Date(), to: harvestDate)
                        if let days = components.day, days >= 0 {
                            HStack {
                                ProgressView(value: Double(plant.daysToMaturity - days), total: Double(plant.daysToMaturity))
                                    .progressViewStyle(.linear)
                                
                                Text("\(days) days left")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top, 8)
                        }
                    }
                    
                    if let gardenBed = planting.gardenBed {
                        Text("Location: \(gardenBed.name)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    } else if let garden = planting.garden {
                        Text("Location: \(garden.name)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                    
                    Text("Position: (\(planting.xPosition.formatted())ft, \(planting.yPosition.formatted())ft)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                
                // Harvest logs
                VStack(alignment: .leading) {
                    HStack {
                        Text("Harvest Logs")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button {
                            showingAddHarvest = true
                        } label: {
                            Label("Add Harvest", systemImage: "plus")
                                .font(.callout)
                        }
                    }
                    
                    if let logs = planting.harvestLogs, !logs.isEmpty {
                        let sortedLogs = logs.sorted { $0.date > $1.date }
                        
                        ForEach(sortedLogs) { log in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(log.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text("\(log.quantity.formatted()) \(log.unit.rawValue)")
                                        .font(.subheadline)
                                        .bold()
                                }
                                
                                if let quality = log.quality {
                                    HStack {
                                        Text("Quality:")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        HStack(spacing: 2) {
                                            ForEach(1...5, id: \.self) { star in
                                                Image(systemName: star <= quality ? "star.fill" : "star")
                                                    .foregroundColor(.yellow)
                                                    .font(.caption)
                                            }
                                        }
                                    }
                                    .padding(.top, 2)
                                }
                                
                                if let notes = log.notes, !notes.isEmpty {
                                    Text(notes)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.top, 2)
                                }
                                
                                if let imageData = log.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .padding(.top, 4)
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.vertical, 4)
                            .swipeActions {
                                Button(role: .destructive) {
                                    modelContext.delete(log)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    } else {
                        Text("No harvest logs yet")
                            .foregroundColor(.secondary)
                            .padding(.vertical)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                
                // Growth logs
                VStack(alignment: .leading) {
                    HStack {
                        Text("Growth Log")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button {
                            showingAddGrowthLog = true
                        } label: {
                            Label("Add Entry", systemImage: "plus")
                                .font(.callout)
                        }
                    }
                    
                    if let logs = planting.growthLogs, !logs.isEmpty {
                        let sortedLogs = logs.sorted { $0.date > $1.date }
                        
                        ForEach(sortedLogs) { log in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(log.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    if let stage = log.stage {
                                        Text(stage.rawValue)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(Color.green)
                                            .clipShape(Capsule())
                                    }
                                }
                                
                                if let notes = log.notes, !notes.isEmpty {
                                    Text(notes)
                                        .font(.subheadline)
                                        .padding(.top, 2)
                                }
                                
                                if let imageData = log.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .padding(.top, 4)
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.vertical, 4)
                            .swipeActions {
                                Button(role: .destructive) {
                                    modelContext.delete(log)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    } else {
                        Text("No growth log entries yet")
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
        .navigationTitle("Planting Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddHarvest) {
            NavigationStack {
                AddHarvestLogView(planting: planting)
            }
        }
        .sheet(isPresented: $showingEditPlanting) {
            NavigationStack {
                EditPlantingView(planting: planting)
            }
        }
        .sheet(isPresented: $showingAddGrowthLog) {
            NavigationStack {
                AddPlantingGrowthLogView(planting: planting)
            }
        }
    }
}

#Preview {
    PlantingDetailView(planting: Planting(datePlanted: Date(), quantity: 10, status: .active, xPosition: 0.0, yPosition: 0.0))
}
