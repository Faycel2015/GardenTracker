//
//  CompanionPlantingService.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

/// Service that provides companion planting recommendations
class CompanionPlantingService {
    static let shared = CompanionPlantingService()
    
    private init() {}
    
    /// Get companion planting recommendations for a given plant
    /// - Parameter plant: The plant to find companions for
    /// - Returns: Array of plant names that are good companions
    func getCompanionPlants(for plant: Plant) -> [String] {
        return plant.companionPlants
    }
    
    /// Get plants that should not be planted near a given plant
    /// - Parameter plant: The plant to find adversaries for
    /// - Returns: Array of plant names that should be avoided
    func getAdversaryPlants(for plant: Plant) -> [String] {
        return plant.adversaryPlants
    }
    
    /// Check if two plants are compatible for planting together
    /// - Parameters:
    ///   - plantA: First plant
    ///   - plantB: Second plant
    /// - Returns: Compatibility status
    func checkCompatibility(between plantA: Plant, and plantB: Plant) -> PlantCompatibility {
        // Check if either plant lists the other as a companion
        let isCompanion = plantA.companionPlants.contains(plantB.name) ||
                         plantB.companionPlants.contains(plantA.name)
        
        // Check if either plant lists the other as an adversary
        let isAdversary = plantA.adversaryPlants.contains(plantB.name) ||
                         plantB.adversaryPlants.contains(plantA.name)
        
        if isAdversary {
            return .incompatible
        } else if isCompanion {
            return .companion
        } else {
            return .neutral
        }
    }
    
    /// Get companion planting recommendations for a garden bed
    /// - Parameters:
    ///   - existingPlants: Plants already in the garden bed
    ///   - allPlants: All available plants to choose from
    /// - Returns: Array of recommended plants
    func getRecommendations(for existingPlants: [Plant], from allPlants: [Plant]) -> [Plant] {
        guard !existingPlants.isEmpty else { return allPlants }
        
        var recommendations = [Plant]()
        
        // Collect all companion plants for the existing plants
        var companionNames = Set<String>()
        for plant in existingPlants {
            companionNames.formUnion(plant.companionPlants)
        }
        
        // Collect all adversary plants for the existing plants
        var adversaryNames = Set<String>()
        for plant in existingPlants {
            adversaryNames.formUnion(plant.adversaryPlants)
        }
        
        // Filter plants that are companions and not adversaries
        for plant in allPlants {
            // Skip plants that are already in the garden bed
            if existingPlants.contains(where: { $0.id == plant.id }) {
                continue
            }
            
            // Skip plants that are adversaries to any existing plant
            if adversaryNames.contains(plant.name) {
                continue
            }
            
            // Prioritize plants that are companions
            if companionNames.contains(plant.name) {
                recommendations.append(plant)
            }
            // Include other plants that aren't adversaries
            else {
                let isAdversaryToAny = existingPlants.contains(where: {
                    plant.adversaryPlants.contains($0.name)
                })
                
                if !isAdversaryToAny {
                    recommendations.append(plant)
                }
            }
        }
        
        return recommendations
    }
}

enum PlantCompatibility {
    case companion
    case neutral
    case incompatible
}
