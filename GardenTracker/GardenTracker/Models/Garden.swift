//
//  Garden.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

// MARK: - Garden Model
@Model
final class Garden {
    var name: String
    var width: Double // in feet
    var length: Double // in feet
    var location: String?
    var soilType: String?
    var hardinessZone: String?
    var dateCreated: Date
    
    // Relationships
    @Relationship(deleteRule: .cascade) var beds: [GardenBed]?
    @Relationship(deleteRule: .cascade) var plantings: [Planting]?
    @Relationship(deleteRule: .cascade) var tasks: [Task]?
    
    init(
        name: String,
        width: Double,
        length: Double,
        location: String? = nil,
        soilType: String? = nil,
        hardinessZone: String? = nil,
        dateCreated: Date = Date()
    ) {
        self.name = name
        self.width = width
        self.length = length
        self.location = location
        self.soilType = soilType
        self.hardinessZone = hardinessZone
        self.dateCreated = dateCreated
    }
}
