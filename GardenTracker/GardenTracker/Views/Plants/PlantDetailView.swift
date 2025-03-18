//
//  PlantDetailView.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

struct PlantDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var plant: Plant
    @State private var showingEditPlant = false
    @State private var showingAddNote = false
    @State private var selectedImage: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var showingGrowthLog = false
    @State private var userHardinessZone: String = "7b"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Plant info card
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(plant.name)
                                .font(.title)
                                .bold()
                            
                            Text(plant.type)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            showingEditPlant = true
                        } label: {
                            Image(systemName: "pencil")
                                .padding(8)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                        }
                    }
                    
                    Text(plant.plantDescription)
                        .padding(.top, 4)
                }
                
                // Planting Season Information
                VStack(alignment: .leading) {
                    Text("Planting Information")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    PlantingSeasonIndicator(plant: plant, hardinessZone: userHardinessZone)
                    
                    // Planting tips based on season
                    if let tip = getPlantingTip() {
                        HStack(alignment: .top) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(AppColors.secondary)
                                .padding(.top, 2)
                            
                            Text(tip)
                                .font(.subheadline)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                
                // Growing info
                VStack(alignment: .leading) {
                    Text("Growing Information")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    GrowingInfoRow(icon: "ruler", label: "Spacing", value: "\(plant.spacing.formatted()) inches")
                    GrowingInfoRow(icon: "calendar", label: "Days to Maturity", value: "\(plant.daysToMaturity) days")
                    GrowingInfoRow(icon: "arrow.down.to.line", label: "Planting Depth", value: "\(plant.plantingDepth.formatted()) inches")
                    GrowingInfoRow(icon: "sun.max", label: "Sun Requirement", value: plant.sunRequirement.rawValue)
                    GrowingInfoRow(icon: "drop", label: "Water Requirement", value: plant.waterRequirement.rawValue)
                    
                    Text("Growing Seasons")
                        .font(.subheadline)
                        .padding(.top, 4)
                    
                    TagsView(tags: plant.growingSeasons.map { $0.rawValue })
                    
                    if !plant.companionPlants.isEmpty {
                        Text("Companion Plants")
                            .font(.subheadline)
                            .padding(.top, 4)
                        
                        TagsView(tags: plant.companionPlants)
                    }
                    
                    if !plant.adversaryPlants.isEmpty {
                        Text("Plants to Avoid")
                            .font(.subheadline)
                            .padding(.top, 4)
                        
                        TagsView(tags: plant.adversaryPlants, tagColor: .red)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                
                // Growth stages
                if !plant.growthStages.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Growth Stages")
                            .font(.headline)
                            .padding(.bottom, 4)
                        
                        ForEach(plant.growthStages, id: \.self) { stage in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 8))
                                
                                Text(stage.rawValue)
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
                }
                
                // Growth Log
                VStack(alignment: .leading) {
                    HStack {
                        Text("Growth Log")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button {
                            showingGrowthLog = true
                        } label: {
                            Label("Add Entry", systemImage: "plus")
                                .font(.callout)
                        }
                    }
                    
                    if let logs = plant.growthLogs, !logs.isEmpty {
                        let sortedLogs = logs.sorted { $0.date > $1.date }
                        
                        ForEach(sortedLogs.prefix(3)) { log in
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
                        }
                        
                        if logs.count > 3 {
                            NavigationLink("View All (\(logs.count) entries)") {
                                PlantGrowthLogView(plant: plant)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
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
                
                // Notes
                VStack(alignment: .leading) {
                    HStack {
                        Text("Notes")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button {
                            showingAddNote = true
                        } label: {
                            Label("Add Note", systemImage: "plus")
                                .font(.callout)
                        }
                    }
                    
                    if let notes = plant.notes, !notes.isEmpty {
                        let sortedNotes = notes.sorted { $0.date > $1.date }
                        
                        ForEach(sortedNotes) { note in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(note.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text(note.category.rawValue)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(noteCategoryColor(note.category).opacity(0.2))
                                        .foregroundColor(noteCategoryColor(note.category))
                                        .clipShape(Capsule())
                                }
                                
                                Text(note.content)
                                    .font(.subheadline)
                                    .padding(.top, 2)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.vertical, 4)
                            .swipeActions {
                                Button(role: .destructive) {
                                    modelContext.delete(note)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    } else {
                        Text("No notes yet")
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
        .navigationTitle("Plant Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditPlant) {
            NavigationStack {
                EditPlantView(plant: plant)
            }
        }
        .sheet(isPresented: $showingAddNote) {
            NavigationStack {
                AddPlantNoteView(plant: plant)
            }
        }
        .sheet(isPresented: $showingGrowthLog) {
            NavigationStack {
                AddGrowthLogView(plant: plant)
            }
        }
    }
    
    private func getPlantingTip() -> String? {
        let currentSeason = Date().currentGrowingSeason
        
        if plant.growingSeasons.contains(currentSeason) || plant.growingSeasons.contains(.yearRound) {
            switch currentSeason {
            case .spring:
                return "Spring planting tip: Ensure soil has warmed to at least 50°F before planting. Consider starting indoors and transplanting for an earlier harvest."
            case .summer:
                return "Summer planting tip: Provide shade for young plants during the hottest part of the day. Water deeply in the mornings to reduce evaporation."
            case .fall:
                return "Fall planting tip: Plant 6-8 weeks before the first expected frost. Protect from early frosts with row covers if needed."
            case .winter:
                return "Winter planting tip: Use cold frames or high tunnels to extend growing season. Choose cold-hardy varieties for best results."
            default:
                return nil
            }
        } else {
            return "Currently not in ideal planting season. Consider starting seeds indoors or waiting for the recommended season."
        }
    }
    
    private func noteCategoryColor(_ category: NoteCategory) -> Color {
        switch category {
        case .general:
            return .blue
        case .disease:
            return .red
        case .pest:
            return .orange
        case .tip:
            return .green
        case .observation:
            return .purple
        }
    }
}

#Preview {
    PlantDetailView(plant: Plant(
        name: "Tomato",
        type: "Vegetable",
        plantDescription: "A popular garden vegetable that produces red fruits.",
        spacing: 24.0,
        daysToMaturity: 80,
        sunRequirement: .fullSun,
        waterRequirement: .moderate,
        plantingDepth: 0.25
    ))
}
