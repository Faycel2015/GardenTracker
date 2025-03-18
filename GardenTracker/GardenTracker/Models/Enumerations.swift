//
//  Enumerations.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData
import WeatherKit
import MapKit

// MARK: - Enumerations
enum SunRequirement: String, Codable, CaseIterable {
    case fullSun = "Full Sun"
    case partialSun = "Partial Sun"
    case partialShade = "Partial Shade"
    case fullShade = "Full Shade"
}

enum WaterRequirement: String, Codable, CaseIterable {
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
}

enum GrowingSeason: String, Codable, CaseIterable {
    case spring = "Spring"
    case summer = "Summer"
    case fall = "Fall"
    case winter = "Winter"
    case yearRound = "Year Round"
}

enum GrowthStage: String, Codable, CaseIterable {
    case seed = "Seed"
    case germination = "Germination"
    case seedling = "Seedling"
    case vegetative = "Vegetative Growth"
    case flowering = "Flowering"
    case fruiting = "Fruiting"
    case mature = "Mature"
    case harvest = "Ready for Harvest"
}

enum PlantingStatus: String, Codable, CaseIterable {
    case planned = "Planned"
    case active = "Active"
    case harvested = "Harvested"
    case failed = "Failed"
    case removed = "Removed"
}

enum TaskType: String, Codable, CaseIterable {
    case planting = "Planting"
    case watering = "Watering"
    case fertilizing = "Fertilizing"
    case pruning = "Pruning"
    case weeding = "Weeding"
    case harvesting = "Harvesting"
    case pestControl = "Pest Control"
    case maintenance = "Maintenance"
    case other = "Other"
}

enum RecurrencePattern: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case biweekly = "Bi-weekly"
    case monthly = "Monthly"
    case custom = "Custom"
}

enum HarvestUnit: String, Codable, CaseIterable {
    case ounces = "oz"
    case pounds = "lb"
    case grams = "g"
    case kilograms = "kg"
    case count = "count"
    case bunches = "bunches"
}

enum NoteCategory: String, Codable, CaseIterable {
    case general = "General"
    case disease = "Disease"
    case pest = "Pest"
    case tip = "Tip"
    case observation = "Observation"
}
