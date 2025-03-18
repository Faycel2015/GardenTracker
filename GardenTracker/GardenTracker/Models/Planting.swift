//
//  Planting.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

// MARK: - Planting Model
@Model
final class Planting {
    var datePlanted: Date
    var quantity: Int
    var status: PlantingStatus
    var xPosition: Double // position in the garden bed
    var yPosition: Double // position in the garden bed
    var expectedHarvestDate: Date?
    
    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \Plant.plantings) var plant: Plant?
    @Relationship(deleteRule: .cascade, inverse: \GardenBed.plantings) var gardenBed: GardenBed?
    @Relationship(deleteRule: .cascade, inverse: \Garden.plantings) var garden: Garden?
    
    // Add these relationships to fix the errors
    @Relationship(deleteRule: .cascade) var growthLogs: [GrowthLog]?
    @Relationship(deleteRule: .cascade) var harvestLogs: [HarvestLog]?
    
    init(
        datePlanted: Date,
        quantity: Int,
        status: PlantingStatus = .active,
        xPosition: Double,
        yPosition: Double,
        expectedHarvestDate: Date? = nil
    ) {
        self.datePlanted = datePlanted
        self.quantity = quantity
        self.status = status
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.expectedHarvestDate = expectedHarvestDate
    }
}
