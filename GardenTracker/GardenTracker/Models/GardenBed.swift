//
//  GardenBed.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

// MARK: - GardenBed Model
@Model
final class GardenBed {
    var name: String
    var width: Double // in feet
    var length: Double // in feet
    var xPosition: Double // position in the garden
    var yPosition: Double // position in the garden
    var soilType: String?
    var dateCreated: Date
    
    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \Garden.beds) var garden: Garden?
    @Relationship(deleteRule: .cascade) var plantings: [Planting]?
    @Relationship(deleteRule: .cascade) var cropRotationHistory: [CropRotation]?
    
    init(
        name: String,
        width: Double,
        length: Double,
        xPosition: Double,
        yPosition: Double,
        soilType: String? = nil,
        dateCreated: Date = Date()
    ) {
        self.name = name
        self.width = width
        self.length = length
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.soilType = soilType
        self.dateCreated = dateCreated
    }
}
