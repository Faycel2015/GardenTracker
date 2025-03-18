//
//  CropRotation.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData
import WeatherKit
import MapKit

// MARK: - Crop Rotation Model
@Model
final class CropRotation {
    var year: Int
    var season: GrowingSeason
    var cropFamily: String
    
    // Relationships
    @Relationship(deleteRule: .nullify, inverse: \GardenBed.cropRotationHistory) var gardenBed: GardenBed?
    
    init(
        year: Int,
        season: GrowingSeason,
        cropFamily: String
    ) {
        self.year = year
        self.season = season
        self.cropFamily = cropFamily
    }
}

// MARK: - Weather Model
struct WeatherData {
    var temperature: Double
    var conditions: String
    var precipitation: Double
    var humidity: Double
    var windSpeed: Double
    var date: Date
    
    // Not stored in SwiftData - fetched from WeatherKit
}
