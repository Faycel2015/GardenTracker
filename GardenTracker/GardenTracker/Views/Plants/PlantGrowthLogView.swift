//
//  PlantGrowthLogView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct PlantGrowthLogView: View {
    let plant: Plant
    
    var sortedLogs: [GrowthLog] {
        if let logs = plant.growthLogs {
            return Array(logs).sorted { $0.date > $1.date }
        }
        return []
    }
    
    var body: some View {
        List {
            if sortedLogs.isEmpty {
                Text("No growth logs recorded yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
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
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("\(plant.name) Growth Log")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.inset)
    }
}

// MARK: - Preview
#Preview {
    // Creating a preview that doesn't require a model context
    let previewPlant = Plant(
        name: "Tomato",
        type: "Vegetable",
        plantDescription: "A popular garden vegetable that produces red fruits.",
        spacing: 24.0,
        daysToMaturity: 80,
        sunRequirement: .fullSun,
        waterRequirement: .moderate,
        plantingDepth: 0.25,
        growthStages: [.seed, .seedling, .vegetative, .flowering, .fruiting, .harvest]
    )
    
    // Create some sample growth logs
    let log1 = GrowthLog(
        date: Date().addingTimeInterval(-86400 * 7), // 7 days ago
        notes: "Seeds have sprouted! Small green shoots visible.",
        stage: .seedling
    )
    
    let log2 = GrowthLog(
        date: Date(), // Today
        notes: "Plants are growing well. About 6 inches tall now.",
        stage: .vegetative
    )
    
    // Set up relationships for preview
    log1.plant = previewPlant
    log2.plant = previewPlant
    
    // Create a container with the relationships
    let container = try! ModelContainer(for: Plant.self, GrowthLog.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext
    
    // Add everything to the context
    context.insert(previewPlant)
    context.insert(log1)
    context.insert(log2)
    
    return NavigationStack {
        PlantGrowthLogView(plant: previewPlant)
    }
    .modelContainer(container)
}
