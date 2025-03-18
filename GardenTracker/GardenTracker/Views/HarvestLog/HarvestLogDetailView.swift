//
//  HarvestLogDetailView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI

struct HarvestLogDetailView: View {
    let harvestLog: HarvestLog
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Harvest info
                VStack(alignment: .leading) {
                    HStack {
                        Text(harvestLog.planting?.plant?.name ?? "Unknown Plant")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Text("\(harvestLog.quantity.formatted()) \(harvestLog.unit.rawValue)")
                            .font(.headline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .clipShape(Capsule())
                    }
                    
                    Text("Harvested on \(harvestLog.date.formatted(date: .long, time: .shortened))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                    
                    if let quality = harvestLog.quality {
                        HStack {
                            Text("Quality:")
                                .font(.subheadline)
                            
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= quality ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding(.top, 8)
                    }
                    
                    if let notes = harvestLog.notes {
                        Divider()
                            .padding(.vertical, 8)
                        
                        Text("Notes:")
                            .font(.headline)
                            .padding(.bottom, 4)
                        
                        Text(notes)
                            .font(.body)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                
                // Photo
                if let imageData = harvestLog.imageData, let uiImage = UIImage(data: imageData) {
                    VStack(alignment: .leading) {
                        Text("Photo")
                            .font(.headline)
                            .padding(.bottom, 8)
                        
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
                }
                
                // Plant and location info
                if let planting = harvestLog.planting {
                    VStack(alignment: .leading) {
                        Text("Plant Information")
                            .font(.headline)
                            .padding(.bottom, 8)
                        
                        if let plant = planting.plant {
                            HStack {
                                Text("Plant")
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Text(plant.name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Text("Type")
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Text(plant.type)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        HStack {
                            Text("Status")
                                .font(.subheadline)
                            
                            Spacer()
                            
                            StatusBadge(status: planting.status)
                        }
                        
                        HStack {
                            Text("Planted On")
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Text(planting.datePlanted.formatted(date: .abbreviated, time: .omitted))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        if let gardenBed = planting.gardenBed {
                            Divider()
                                .padding(.vertical, 8)
                            
                            HStack {
                                Text("Garden Bed")
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Text(gardenBed.name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            if let garden = gardenBed.garden {
                                HStack {
                                    Text("Garden")
                                        .font(.subheadline)
                                    
                                    Spacer()
                                    
                                    Text(garden.name)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        } else if let garden = planting.garden {
                            Divider()
                                .padding(.vertical, 8)
                            
                            HStack {
                                Text("Garden")
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Text(garden.name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
                }
            }
            .padding()
        }
        .navigationTitle("Harvest Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let plant = Plant(
        name: "Tomato",
        type: "Vegetable",
        plantDescription: "Juicy red fruit",
        spacing: 24,
        daysToMaturity: 80,
        sunRequirement: .fullSun,
        waterRequirement: .moderate,
        plantingDepth: 0.5
    )
    
    // Fixed: Using Calendar.date(byAdding:) instead of addingTimeInterval
    let plantingDate = Calendar.current.date(byAdding: .day, value: -60, to: Date())! // 60 days ago
    
    let planting = Planting(
        datePlanted: plantingDate,
        quantity: 3,
        status: .harvested,
        xPosition: 1.0,
        yPosition: 2.0
    )
    planting.plant = plant
    
    let harvestLog = HarvestLog(
        date: Date(),
        quantity: 2.5,
        unit: .pounds,
        quality: 4,
        notes: "Great flavor, slightly smaller than expected. Will plant more next season."
    )
    harvestLog.planting = planting
    
    return NavigationStack {
        HarvestLogDetailView(harvestLog: harvestLog)
    }
}
