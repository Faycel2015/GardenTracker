//
//  EditPlantView.swift
//  GardenTracker
//
//  Created by FayTek on 3/11/25.
//

import SwiftUI
import SwiftData

struct EditPlantView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var plant: Plant
    
    @State private var name: String
    @State private var type: String
    @State private var description: String
    @State private var spacing: Double
    @State private var daysToMaturity: Int
    @State private var sunRequirement: SunRequirement
    @State private var waterRequirement: WaterRequirement
    @State private var plantingDepth: Double
    @State private var companionPlants: String
    @State private var adversaryPlants: String
    @State private var growingSeasons: Set<GrowingSeason>
    @State private var growthStages: Set<GrowthStage>
    
    init(plant: Plant) {
        self.plant = plant
        _name = State(initialValue: plant.name)
        _type = State(initialValue: plant.type)
        _description = State(initialValue: plant.plantDescription)
        _spacing = State(initialValue: plant.spacing)
        _daysToMaturity = State(initialValue: plant.daysToMaturity)
        _sunRequirement = State(initialValue: plant.sunRequirement)
        _waterRequirement = State(initialValue: plant.waterRequirement)
        _plantingDepth = State(initialValue: plant.plantingDepth)
        _companionPlants = State(initialValue: plant.companionPlants.joined(separator: ", "))
        _adversaryPlants = State(initialValue: plant.adversaryPlants.joined(separator: ", "))
        _growingSeasons = State(initialValue: Set(plant.growingSeasons))
        _growthStages = State(initialValue: Set(plant.growthStages))
    }
    
    var body: some View {
        Form {
            Section("Basic Information") {
                TextField("Plant Name", text: $name)
                TextField("Type/Category", text: $type)
                TextField("Description", text: $description, axis: .vertical)
                    .lineLimit(3...6)
            }
            
            Section("Growing Requirements") {
                HStack {
                    Text("Spacing (inches)")
                    Spacer()
                    TextField("Spacing", value: $spacing, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                }
                
                HStack {
                    Text("Days to Maturity")
                    Spacer()
                    TextField("Days", value: $daysToMaturity, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                }
                
                HStack {
                    Text("Planting Depth (inches)")
                    Spacer()
                    TextField("Depth", value: $plantingDepth, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                }
                
                Picker("Sun Requirement", selection: $sunRequirement) {
                    ForEach(SunRequirement.allCases, id: \.self) { requirement in
                        Text(requirement.rawValue).tag(requirement)
                    }
                }
                
                Picker("Water Requirement", selection: $waterRequirement) {
                    ForEach(WaterRequirement.allCases, id: \.self) { requirement in
                        Text(requirement.rawValue).tag(requirement)
                    }
                }
            }
            
            Section("Growing Seasons") {
                ForEach(GrowingSeason.allCases, id: \.self) { season in
                    if season != .yearRound {
                        Button {
                            toggleSeason(season)
                        } label: {
                            HStack {
                                Text(season.rawValue)
                                Spacer()
                                if growingSeasons.contains(season) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Button {
                    toggleSeason(.yearRound)
                } label: {
                    HStack {
                        Text(GrowingSeason.yearRound.rawValue)
                        Spacer()
                        if growingSeasons.contains(.yearRound) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            
            Section("Growth Stages") {
                ForEach(GrowthStage.allCases, id: \.self) { stage in
                    Button {
                        toggleGrowthStage(stage)
                    } label: {
                        HStack {
                            Text(stage.rawValue)
                            Spacer()
                            if growthStages.contains(stage) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Section("Companion Planting") {
                TextField("Companion Plants (comma separated)", text: $companionPlants)
                TextField("Plants to Avoid (comma separated)", text: $adversaryPlants)
            }
            
            Section {
                Button("Save Changes") {
                    let companionArray = companionPlants
                        .components(separatedBy: ",")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
                    
                    let adversaryArray = adversaryPlants
                        .components(separatedBy: ",")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
                    
                    let seasonArray = growingSeasons.isEmpty ? [.yearRound] : Array(growingSeasons)
                    let stagesArray = Array(growthStages)
                    
                    plant.name = name
                    plant.type = type
                    plant.plantDescription = description
                    plant.spacing = spacing
                    plant.daysToMaturity = daysToMaturity
                    plant.sunRequirement = sunRequirement
                    plant.waterRequirement = waterRequirement
                    plant.plantingDepth = plantingDepth
                    plant.companionPlants = companionArray
                    plant.adversaryPlants = adversaryArray
                    plant.growingSeasons = seasonArray
                    plant.growthStages = stagesArray
                    
                    dismiss()
                }
                .disabled(name.isEmpty || type.isEmpty || spacing <= 0 || daysToMaturity <= 0)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Edit Plant")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
    
    private func toggleSeason(_ season: GrowingSeason) {
        if season == .yearRound {
            if growingSeasons.contains(.yearRound) {
                growingSeasons.remove(.yearRound)
            } else {
                growingSeasons = [.yearRound]
            }
        } else {
            if growingSeasons.contains(.yearRound) {
                growingSeasons.remove(.yearRound)
            }
            
            if growingSeasons.contains(season) {
                growingSeasons.remove(season)
            } else {
                growingSeasons.insert(season)
            }
        }
    }
    
    private func toggleGrowthStage(_ stage: GrowthStage) {
        if growthStages.contains(stage) {
            growthStages.remove(stage)
        } else {
            growthStages.insert(stage)
        }
    }
}

#Preview {
    EditPlantView(plant: Plant(
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
