//
//  PlantingCalendarService.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

/// Service that provides planting calendar recommendations
class PlantingCalendarService {
    static let shared = PlantingCalendarService()
    
    // Hardiness zone planting windows (approximate)
    // Format: [zone: [season: [month ranges]]]
    private let plantingWindows: [String: [GrowingSeason: [(Int, Int)]]] = [
        "1": [
            .spring: [(5, 6)],
            .summer: [(6, 8)],
            .fall: [(8, 9)],
            .winter: []
        ],
        "2": [
            .spring: [(5, 6)],
            .summer: [(6, 8)],
            .fall: [(8, 9)],
            .winter: []
        ],
        "3": [
            .spring: [(4, 6)],
            .summer: [(6, 8)],
            .fall: [(8, 9)],
            .winter: []
        ],
        "4": [
            .spring: [(4, 6)],
            .summer: [(6, 8)],
            .fall: [(8, 9)],
            .winter: []
        ],
        "5": [
            .spring: [(4, 5)],
            .summer: [(5, 8)],
            .fall: [(8, 10)],
            .winter: []
        ],
        "6": [
            .spring: [(3, 5)],
            .summer: [(5, 8)],
            .fall: [(8, 10)],
            .winter: []
        ],
        "7": [
            .spring: [(3, 5)],
            .summer: [(5, 8)],
            .fall: [(8, 11)],
            .winter: [(11, 2)]
        ],
        "8": [
            .spring: [(2, 4)],
            .summer: [(5, 8)],
            .fall: [(8, 11)],
            .winter: [(11, 2)]
        ],
        "9": [
            .spring: [(2, 4)],
            .summer: [(4, 8)],
            .fall: [(9, 11)],
            .winter: [(11, 3)]
        ],
        "10": [
            .spring: [(1, 3)],
            .summer: [(4, 8)],
            .fall: [(9, 12)],
            .winter: [(12, 3)]
        ],
        "11": [
            .spring: [(1, 3)],
            .summer: [(3, 9)],
            .fall: [(9, 12)],
            .winter: [(12, 3)]
        ],
        "12": [
            .spring: [(1, 3)],
            .summer: [(3, 9)],
            .fall: [(9, 12)],
            .winter: [(12, 3)]
        ],
        "13": [
            .spring: [(1, 3)],
            .summer: [(3, 9)],
            .fall: [(9, 12)],
            .winter: [(12, 3)]
        ]
    ]
    
    private init() {}
    
    /// Get suitable planting seasons for a plant in a specific hardiness zone
    /// - Parameters:
    ///   - plant: The plant
    ///   - hardinessZone: The hardiness zone
    /// - Returns: Array of growing seasons
    func getSuitablePlantingSeasons(for plant: Plant, in hardinessZone: String) -> [GrowingSeason] {
        // If the plant can grow year-round, it can be planted in any season
        if plant.growingSeasons.contains(.yearRound) {
            return [.spring, .summer, .fall, .winter]
        }
        
        let zone = hardinessZone.trimmingCharacters(in: .letters)
        
        // Filter plant's growing seasons by the zone's planting windows
        if let zoneWindows = plantingWindows[zone] {
            return plant.growingSeasons.filter { season in
                if let windows = zoneWindows[season], !windows.isEmpty {
                    return true
                }
                return false
            }
        }
        
        // If zone not found, return all the plant's growing seasons
        return plant.growingSeasons
    }
    
    /// Get recommended planting date range for a plant in a specific zone and season
    /// - Parameters:
    ///   - plant: The plant
    ///   - hardinessZone: The hardiness zone
    ///   - season: The growing season
    /// - Returns: Tuple of (start date, end date) or nil if not applicable
    func getPlantingDateRange(for plant: Plant, in hardinessZone: String, season: GrowingSeason) -> (Date, Date)? {
        // If plant can't grow in this season, return nil
        if !plant.growingSeasons.contains(season) && !plant.growingSeasons.contains(.yearRound) {
            return nil
        }
        
        let zone = hardinessZone.trimmingCharacters(in: .letters)
        
        // Get the planting window for this zone and season
        guard let zoneWindows = plantingWindows[zone],
              let seasonWindows = zoneWindows[season],
              !seasonWindows.isEmpty else {
            return nil
        }
        
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        var dateComponents = DateComponents()
        dateComponents.year = currentYear
        
        // Use the first window for simplicity
        let window = seasonWindows[0]
        
        // Create start date
        dateComponents.month = window.0
        dateComponents.day = 1
        guard let startDate = calendar.date(from: dateComponents) else {
            return nil
        }
        
        // Create end date
        let endMonth = window.1  // Changed from var to let
        if endMonth < window.0 {
            // Handle winter seasons that span December to January
            dateComponents.year = currentYear + 1
        }
        dateComponents.month = endMonth
        
        // Set to last day of month
        if let lastDay = calendar.range(of: .day, in: .month, for: calendar.date(from: dateComponents)!)?.count {
            dateComponents.day = lastDay
        } else {
            dateComponents.day = 28 // Fallback
        }
        
        guard let endDate = calendar.date(from: dateComponents) else {
            return nil
        }
        
        return (startDate, endDate)
    }
    
    /// Check if a plant can be planted now based on the current date and hardiness zone
    /// - Parameters:
    ///   - plant: The plant
    ///   - hardinessZone: The hardiness zone
    /// - Returns: Whether the plant can be planted now
    func canPlantNow(_ plant: Plant, in hardinessZone: String) -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: currentDate)
        
        let zone = hardinessZone.trimmingCharacters(in: .letters)
        
        // Check each season the plant can grow in
        let seasons = plant.growingSeasons.contains(.yearRound) ?
                     [GrowingSeason.spring, .summer, .fall, .winter] :
                     plant.growingSeasons
        
        for season in seasons {
            if let zoneWindows = plantingWindows[zone],
               let seasonWindows = zoneWindows[season] {
                for window in seasonWindows {
                    let startMonth = window.0
                    let endMonth = window.1
                    
                    if endMonth >= startMonth {
                        // Normal range (e.g., 4-6)
                        if currentMonth >= startMonth && currentMonth <= endMonth {
                            return true
                        }
                    } else {
                        // Range spans year end (e.g., 11-2)
                        if currentMonth >= startMonth || currentMonth <= endMonth {
                            return true
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    /// Get all plants that can be planted now based on the current date and hardiness zone
    /// - Parameters:
    ///   - plants: Array of all plants
    ///   - hardinessZone: The hardiness zone
    /// - Returns: Array of plants that can be planted now
    func getPlantsToPlantNow(from plants: [Plant], in hardinessZone: String) -> [Plant] {
        return plants.filter { canPlantNow($0, in: hardinessZone) }
    }
    
    /// Get the current growing season based on the date and hardiness zone
    /// - Parameters:
    ///   - date: The date
    ///   - hardinessZone: The hardiness zone
    /// - Returns: The current growing season
    func getCurrentSeason(on date: Date = Date(), in hardinessZone: String) -> GrowingSeason {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        // Simple season determination based on month
        switch month {
        case 3...5:
            return .spring
        case 6...8:
            return .summer
        case 9...11:
            return .fall
        default:
            return .winter
        }
    }
}
