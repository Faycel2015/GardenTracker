//
//  CropRotationService.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

/// Service that provides crop rotation recommendations
class CropRotationService {
    static let shared = CropRotationService()
    
    // Common plant families for crop rotation
    private let plantFamilies = [
        "Allium": ["Onion", "Garlic", "Leek", "Shallot", "Chive"],
        "Apiaceae": ["Carrot", "Parsley", "Celery", "Parsnip", "Fennel", "Dill"],
        "Asteraceae": ["Lettuce", "Sunflower", "Artichoke", "Endive", "Dandelion"],
        "Brassicaceae": ["Broccoli", "Cauliflower", "Cabbage", "Kale", "Radish", "Turnip", "Arugula"],
        "Cucurbitaceae": ["Cucumber", "Squash", "Pumpkin", "Zucchini", "Melon", "Watermelon"],
        "Fabaceae": ["Bean", "Pea", "Lentil", "Peanut", "Clover", "Alfalfa"],
        "Solanaceae": ["Tomato", "Pepper", "Eggplant", "Potato", "Tomatillo"]
    ]
    
    // Recommended rotation sequence
    private let rotationSequence = [
        "Brassicaceae",  // Heavy feeders
        "Solanaceae",    // Heavy feeders
        "Cucurbitaceae", // Heavy feeders
        "Apiaceae",      // Light feeders
        "Asteraceae",    // Light feeders
        "Allium",        // Light feeders
        "Fabaceae"       // Soil builders
    ]
    
    private init() {}
    
    /// Get the plant family for a given plant
    /// - Parameter plantName: Name of the plant
    /// - Returns: Family name or "Unknown"
    func getPlantFamily(for plantName: String) -> String {
        for (family, plants) in plantFamilies {
            if plants.contains(where: { plantName.lowercased().contains($0.lowercased()) }) {
                return family
            }
        }
        return "Unknown"
    }
    
    /// Get the plant family for a given plant
    /// - Parameter plant: The plant
    /// - Returns: Family name or "Unknown"
    func getPlantFamily(for plant: Plant) -> String {
        return getPlantFamily(for: plant.name)
    }
    
    /// Get plants that belong to a specific family
    /// - Parameters:
    ///   - family: The plant family
    ///   - allPlants: All available plants
    /// - Returns: Array of plants in the specified family
    func getPlantsInFamily(_ family: String, from allPlants: [Plant]) -> [Plant] {
        guard let familyMembers = plantFamilies[family] else { return [] }
        
        return allPlants.filter { plant in
            familyMembers.contains(where: { plant.name.lowercased().contains($0.lowercased()) })
        }
    }
    
    /// Get the recommended next family in the rotation sequence
    /// - Parameter currentFamily: Current plant family
    /// - Returns: Next recommended family
    func getNextFamilyInRotation(after currentFamily: String) -> String {
        guard let index = rotationSequence.firstIndex(of: currentFamily) else {
            // If not in sequence, start with the first family
            return rotationSequence.first ?? "Fabaceae"
        }
        
        let nextIndex = (index + 1) % rotationSequence.count
        return rotationSequence[nextIndex]
    }
    
    /// Get crop rotation history for a garden bed
    /// - Parameter gardenBed: The garden bed
    /// - Returns: Array of crop rotation entries sorted by year and season
    func getRotationHistory(for gardenBed: GardenBed) -> [CropRotation] {
        guard let history = gardenBed.cropRotationHistory else { return [] }
        
        // Sort by year (descending) and then by season
        let seasonOrder: [GrowingSeason] = [.spring, .summer, .fall, .winter]
        
        return history.sorted {
            if $0.year != $1.year {
                return $0.year > $1.year
            } else {
                guard let index1 = seasonOrder.firstIndex(of: $0.season),
                      let index2 = seasonOrder.firstIndex(of: $1.season) else {
                    return false
                }
                return index1 < index2
            }
        }
    }
    
    /// Get recommended plant families for the next planting season
    /// - Parameters:
    ///   - gardenBed: The garden bed
    ///   - season: The target growing season
    ///   - year: The target year
    /// - Returns: Array of recommended plant families
    func getRecommendedFamilies(for gardenBed: GardenBed, in season: GrowingSeason, year: Int) -> [String] {
        let history = getRotationHistory(for: gardenBed)
        
        // Find most recent crop family for this bed
        if let lastRotation = history.first {
            let nextFamily = getNextFamilyInRotation(after: lastRotation.cropFamily)
            return [nextFamily]
        } else {
            // No history, recommend soil builders first
            return ["Fabaceae"]
        }
    }
    
    /// Check if a plant is suitable for planting based on crop rotation principles
    /// - Parameters:
    ///   - plant: The plant to check
    ///   - gardenBed: The garden bed
    /// - Returns: Whether the plant is suitable
    func isPlantSuitableForRotation(_ plant: Plant, in gardenBed: GardenBed) -> Bool {
        let plantFamily = getPlantFamily(for: plant)
        if plantFamily == "Unknown" {
            // If we can't determine the family, assume it's OK
            return true
        }
        
        let history = getRotationHistory(for: gardenBed)
        
        // Check if this family was planted in the last 3 years
        let recentFamilies = history.prefix(3).map { $0.cropFamily }
        
        return !recentFamilies.contains(plantFamily)
    }
}
