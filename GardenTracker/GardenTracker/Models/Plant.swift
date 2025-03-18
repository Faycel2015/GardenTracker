//
//  Plant.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

// MARK: - Plant Model
@Model
final class Plant {
    var name: String
    var type: String
    var plantDescription: String
    var spacing: Double // in inches
    var daysToMaturity: Int
    var sunRequirement: SunRequirement
    var waterRequirement: WaterRequirement
    var plantingDepth: Double // in inches
    
    // Store arrays as encoded strings
    private var _companionPlants: String
    private var _adversaryPlants: String
    private var _growingSeasons: String
    private var _growthStages: String
    
    // Public computed properties
    var companionPlants: [String] {
        get {
            return decodeStringArray(_companionPlants)
        }
        set {
            _companionPlants = encodeStringArray(newValue)
        }
    }
    
    var adversaryPlants: [String] {
        get {
            return decodeStringArray(_adversaryPlants)
        }
        set {
            _adversaryPlants = encodeStringArray(newValue)
        }
    }
    
    var growingSeasons: [GrowingSeason] {
        get {
            return decodeEnum(_growingSeasons) ?? []
        }
        set {
            _growingSeasons = encodeEnum(newValue)
        }
    }
    
    var growthStages: [GrowthStage] {
        get {
            return decodeEnum(_growthStages) ?? []
        }
        set {
            _growthStages = encodeEnum(newValue)
        }
    }
    
    // Helper methods for encoding/decoding
    private func encodeStringArray(_ array: [String]) -> String {
        if let data = try? JSONEncoder().encode(array),
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        return "[]"
    }
    
    private func decodeStringArray(_ string: String) -> [String] {
        if let data = string.data(using: .utf8),
           let array = try? JSONDecoder().decode([String].self, from: data) {
            return array
        }
        return []
    }
    
    private func encodeEnum<T: Codable>(_ array: [T]) -> String {
        if let data = try? JSONEncoder().encode(array),
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        return "[]"
    }
    
    private func decodeEnum<T: Codable>(_ string: String) -> [T]? {
        if let data = string.data(using: .utf8),
           let array = try? JSONDecoder().decode([T].self, from: data) {
            return array
        }
        return nil
    }
    
    // Relationships
    @Relationship(deleteRule: .cascade) var notes: [PlantNote]?
    @Relationship(deleteRule: .cascade) var growthLogs: [GrowthLog]?
    @Relationship(deleteRule: .noAction) var plantings: [Planting]?
    
    init(
        name: String,
        type: String,
        plantDescription: String,
        spacing: Double,
        daysToMaturity: Int,
        sunRequirement: SunRequirement,
        waterRequirement: WaterRequirement,
        plantingDepth: Double,
        companionPlants: [String] = [],
        adversaryPlants: [String] = [],
        growingSeasons: [GrowingSeason] = [],
        growthStages: [GrowthStage] = []
    ) {
        self.name = name
        self.type = type
        self.plantDescription = plantDescription
        self.spacing = spacing
        self.daysToMaturity = daysToMaturity
        self.sunRequirement = sunRequirement
        self.waterRequirement = waterRequirement
        self.plantingDepth = plantingDepth
        
        // Initialize the encoded string versions of arrays
        self._companionPlants = "[]"
        self._adversaryPlants = "[]"
        self._growingSeasons = "[]"
        self._growthStages = "[]"
        
        // Set values using computed properties
        self.companionPlants = companionPlants
        self.adversaryPlants = adversaryPlants
        self.growingSeasons = growingSeasons
        self.growthStages = growthStages
    }
}
