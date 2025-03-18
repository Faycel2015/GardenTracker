//
//  GrowthLog.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

// MARK: - GrowthLog Model
@Model
final class GrowthLog {
    var id: UUID = UUID() // Add this if not present
    var date: Date
    var notes: String?
    var stage: GrowthStage?
    var imageData: Data?
    
    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \Plant.growthLogs) var plant: Plant?
    @Relationship(deleteRule: .cascade, inverse: \Planting.growthLogs) var planting: Planting?
    
    init(
        date: Date = Date(),
        notes: String? = nil,
        stage: GrowthStage? = nil,
        imageData: Data? = nil
    ) {
        self.date = date
        self.notes = notes
        self.stage = stage
        self.imageData = imageData
    }
}
