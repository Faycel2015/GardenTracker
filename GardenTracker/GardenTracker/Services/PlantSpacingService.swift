//
//  PlantSpacingService.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

/// Service that provides plant spacing calculations and recommendations
class PlantSpacingService {
    static let shared = PlantSpacingService()
    
    private init() {}
    
    /// Calculate the number of plants that can fit in a given area with proper spacing
    /// - Parameters:
    ///   - plant: The plant
    ///   - width: Width of the area in feet
    ///   - length: Length of the area in feet
    ///   - plantingMethod: Method of planting (row, square, etc.)
    /// - Returns: The number of plants that can fit
    func calculatePlantCapacity(for plant: Plant, width: Double, length: Double, plantingMethod: PlantingMethod = .row) -> Int {
        // Convert spacing from inches to feet
        let spacingInFeet = plant.spacing / 12.0
        
        switch plantingMethod {
        case .row:
            // Calculate number of rows and plants per row
            let spaceBetweenRows = spacingInFeet
            let spaceBetweenPlants = spacingInFeet
            
            let numberOfRows = Int(width / spaceBetweenRows)
            let plantsPerRow = Int(length / spaceBetweenPlants)
            
            return numberOfRows * plantsPerRow
            
        case .square:
            // Square foot gardening - more efficient use of space
            let plantsPerSquareFoot = 1.0 / (spacingInFeet * spacingInFeet)
            let totalSquareFeet = width * length
            
            return Int(totalSquareFeet * plantsPerSquareFoot)
            
        case .triangular:
            // Triangular/hexagonal pattern - most efficient packing
            let spacingBetweenRows = spacingInFeet * 0.866 // sqrt(3)/2
            
            let numberOfRows = Int(width / spacingBetweenRows)
            let plantsPerOddRow = Int(length / spacingInFeet)
            let plantsPerEvenRow = Int((length - (spacingInFeet / 2)) / spacingInFeet) + 1
            
            let oddRows = (numberOfRows + 1) / 2
            let evenRows = numberOfRows / 2
            
            return (oddRows * plantsPerOddRow) + (evenRows * plantsPerEvenRow)
        }
    }
    
    /// Get positions for plants in a garden bed with proper spacing
    /// - Parameters:
    ///   - plant: The plant
    ///   - bedWidth: Width of the garden bed in feet
    ///   - bedLength: Length of the garden bed in feet
    ///   - plantingMethod: Method of planting (row, square, etc.)
    ///   - quantity: How many plants to position (or maximum if nil)
    /// - Returns: Array of (x, y) position tuples in feet
    func calculatePlantPositions(for plant: Plant, bedWidth: Double, bedLength: Double,
                               plantingMethod: PlantingMethod = .row, quantity: Int? = nil) -> [(Double, Double)] {
        // Convert spacing from inches to feet
        let spacingInFeet = plant.spacing / 12.0
        let maxQuantity = calculatePlantCapacity(for: plant, width: bedWidth, length: bedLength, plantingMethod: plantingMethod)
        let targetQuantity = min(quantity ?? maxQuantity, maxQuantity)
        
        var positions = [(Double, Double)]()
        
        // Add a small margin around the edges
        let margin = 0.5
        let usableWidth = bedWidth - (2 * margin)
        let usableLength = bedLength - (2 * margin)
        
        switch plantingMethod {
        case .row:
            // Create rows of evenly spaced plants
            let spaceBetweenRows = spacingInFeet
            let spaceBetweenPlants = spacingInFeet
            
            let numberOfRows = Int(usableWidth / spaceBetweenRows)
            let plantsPerRow = Int(usableLength / spaceBetweenPlants)
            
            for row in 0..<numberOfRows {
                for col in 0..<plantsPerRow {
                    if positions.count >= targetQuantity {
                        return positions
                    }
                    
                    let x = margin + (Double(row) * spaceBetweenRows) + (spaceBetweenRows / 2)
                    let y = margin + (Double(col) * spaceBetweenPlants) + (spaceBetweenPlants / 2)
                    
                    positions.append((x, y))
                }
            }
            
        case .square:
            // Square foot gardening pattern
            let plantsPerSide = Int(sqrt(1.0 / (spacingInFeet * spacingInFeet)))
            if plantsPerSide == 0 { return positions }
            
            let numCols = Int(usableWidth)
            let numRows = Int(usableLength)
            
            for footRow in 0..<numRows {
                for footCol in 0..<numCols {
                    // For each square foot
                    for row in 0..<plantsPerSide {
                        for col in 0..<plantsPerSide {
                            if positions.count >= targetQuantity {
                                return positions
                            }
                            
                            let cellWidth = 1.0 / Double(plantsPerSide)
                            let cellHeight = 1.0 / Double(plantsPerSide)
                            
                            let x = margin + Double(footCol) + (Double(col) * cellWidth) + (cellWidth / 2)
                            let y = margin + Double(footRow) + (Double(row) * cellHeight) + (cellHeight / 2)
                            
                            positions.append((x, y))
                        }
                    }
                }
            }
            
        case .triangular:
            // Triangular/hexagonal pattern
            let spacingBetweenRows = spacingInFeet * 0.866 // sqrt(3)/2
            
            var row = 0
            var totalPlants = 0
            
            while margin + (Double(row) * spacingBetweenRows) + (spacingInFeet / 2) < bedWidth - margin {
                let isEvenRow = row % 2 == 0
                var col = 0
                let startX = isEvenRow ? 0.0 : spacingInFeet / 2
                
                while margin + startX + (Double(col) * spacingInFeet) + (spacingInFeet / 2) < bedLength - margin {
                    if totalPlants >= targetQuantity {
                        return positions
                    }
                    
                    let x = margin + (Double(row) * spacingBetweenRows) + (spacingBetweenRows / 2)
                    let y = margin + startX + (Double(col) * spacingInFeet) + (spacingInFeet / 2)
                    
                    positions.append((x, y))
                    col += 1
                    totalPlants += 1
                }
                
                row += 1
            }
        }
        
        return positions
    }
    
    /// Recommend a planting method based on the plant type and available space
    /// - Parameters:
    ///   - plant: The plant
    ///   - bedWidth: Width of the garden bed in feet
    ///   - bedLength: Length of the garden bed in feet
    /// - Returns: The recommended planting method
    func recommendPlantingMethod(for plant: Plant, bedWidth: Double, bedLength: Double) -> PlantingMethod {
        // Some plant types benefit from specific planting methods
        switch plant.type.lowercased() {
        case let type where type.contains("lettuce") || type.contains("greens") || type.contains("spinach"):
            // Leafy greens often do well in square foot gardening
            return PlantingMethod.square  // Fixed: fully qualify the enum type
            
        case let type where type.contains("tomato") || type.contains("pepper") || type.contains("eggplant"):
            // Larger fruiting plants need more space, typically in rows
            return PlantingMethod.row  // Fixed: fully qualify the enum type
            
        case let type where type.contains("herb") || type.contains("flower"):
            // Herbs and flowers often benefit from triangular spacing for better visual appeal
            return PlantingMethod.triangular  // Fixed: fully qualify the enum type
            
        default:
            // For small beds, square foot gardening is often most efficient
            if bedWidth < 4 || bedLength < 4 {
                return PlantingMethod.square  // Fixed: fully qualify the enum type
            }
            
            // For larger beds, rows often work better for maintenance access
            return PlantingMethod.row  // Fixed: fully qualify the enum type
        }
    }
    
    /// Calculate optimal plant quantity for a garden bed
    /// - Parameters:
    ///   - plant: The plant
    ///   - gardenBed: The garden bed
    /// - Returns: Recommended quantity of plants
    func calculateOptimalQuantity(for plant: Plant, in gardenBed: GardenBed) -> Int {
        let recommendedMethod = recommendPlantingMethod(for: plant, bedWidth: gardenBed.width, bedLength: gardenBed.length)
        
        return calculatePlantCapacity(for: plant, width: gardenBed.width, length: gardenBed.length, plantingMethod: recommendedMethod)
    }
}

/// Methods for arranging plants in a garden bed
enum PlantingMethod {
    case row          // Traditional row planting
    case square       // Square foot gardening method
    case triangular   // Triangular/hexagonal pattern for efficient spacing
}
