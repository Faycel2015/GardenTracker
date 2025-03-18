//
//  AddPlantView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct AddPlantView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var type = ""
    @State private var description = ""
    @State private var spacing: Double = 12
    @State private var daysToMaturity = 60
    @State private var sunRequirement = SunRequirement.fullSun
    @State private var waterRequirement = WaterRequirement.moderate
    @State private var plantingDepth: Double = 0.25
    @State private var companionPlants = ""
    @State private var adversaryPlants = ""
    @State private var growingSeasons = Set<GrowingSeason>()
    @State private var growthStages = Set<GrowthStage>()
    
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
                Button("Add Plant") {
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
                    
                    let plant = Plant(
                        name: name,
                        type: type,
                        plantDescription: description,
                        spacing: spacing,
                        daysToMaturity: daysToMaturity,
                        sunRequirement: sunRequirement,
                        waterRequirement: waterRequirement,
                        plantingDepth: plantingDepth,
                        companionPlants: companionArray,
                        adversaryPlants: adversaryArray,
                        growingSeasons: seasonArray,
                        growthStages: stagesArray
                    )
                    
                    modelContext.insert(plant)
                    dismiss()
                }
                .disabled(name.isEmpty || type.isEmpty || spacing <= 0 || daysToMaturity <= 0)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Add Plant")
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
    AddPlantView()
}
