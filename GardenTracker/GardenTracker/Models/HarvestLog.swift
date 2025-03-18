//
//  HarvestLog.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

// MARK: - HarvestLog Model
@Model
final class HarvestLog {
    var date: Date
    var quantity: Double
    var unit: HarvestUnit
    var quality: Int? // 1-5 rating
    var notes: String?
    var imageData: Data?
    
    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \Planting.harvestLogs) var planting: Planting?
    
    init(
        date: Date = Date(),
        quantity: Double,
        unit: HarvestUnit,
        quality: Int? = nil,
        notes: String? = nil,
        imageData: Data? = nil
    ) {
        self.date = date
        self.quantity = quantity
        self.unit = unit
        self.quality = quality
        self.notes = notes
        self.imageData = imageData
    }
}
