//
//  PlantingSeasonIndicator.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData
import WeatherKit

struct PlantingSeasonIndicator: View {
    let plant: Plant
    let hardinessZone: String
    
    @State private var currentSeason: GrowingSeason = Date().currentGrowingSeason
    
    // Determine if this plant can be planted now in the user's zone
    private var canPlantNow: Bool {
        PlantingCalendarService.shared.canPlantNow(plant, in: hardinessZone)
    }
    
    // Get suitable planting seasons for this plant in the user's zone
    private var suitableSeasons: [GrowingSeason] {
        PlantingCalendarService.shared.getSuitablePlantingSeasons(for: plant, in: hardinessZone)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Planting recommendation alert
            if canPlantNow {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.successGreen)
                    Text("Good time to plant!")
                        .font(.subheadline)
                        .foregroundColor(.successGreen)
                }
                .padding(8)
                .background(.successGreen.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.infoBlue)
                    Text("Not the ideal planting season")
                        .font(.subheadline)
                        .foregroundColor(.infoBlue)
                }
                .padding(8)
                .background(.infoBlue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // Season timeline
            Text("Ideal planting seasons:")
                .font(.caption)
                .foregroundColor(.secondary)
            
            SeasonTimelineView(
                suitableSeasons: suitableSeasons,
                currentSeason: currentSeason
            )
            
            // Next planting window
            if let nextSeason = getNextPlantingSeason() {
                Text("Next planting window: \(nextSeason.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let (startDate, endDate) = PlantingCalendarService.shared.getPlantingDateRange(
                    for: plant,
                    in: hardinessZone,
                    season: nextSeason
                ) {
                    Text("\(DateFormatting.plantingDateFormatter.string(from: startDate)) - \(DateFormatting.plantingDateFormatter.string(from: endDate))")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
    
    // Find the next suitable planting season
    private func getNextPlantingSeason() -> GrowingSeason? {
        guard !suitableSeasons.isEmpty else { return nil }
        
        // If we can plant now, return current season
        if suitableSeasons.contains(currentSeason) {
            return currentSeason
        }
        
        // Order seasons chronologically from current season
        let orderedSeasons: [GrowingSeason] = [.spring, .summer, .fall, .winter]
        let currentIndex = orderedSeasons.firstIndex(of: currentSeason) ?? 0
        
        // Look for the next suitable season
        for i in 1...4 {
            let nextIndex = (currentIndex + i) % 4
            let nextSeason = orderedSeasons[nextIndex]
            if suitableSeasons.contains(nextSeason) {
                return nextSeason
            }
        }
        
        return suitableSeasons.first
    }
}

#Preview {
    // Create sample plant and hardiness zone for preview
    PlantingSeasonIndicator(
        plant: Plant(
            name: "Tomato",
            type: "Vegetable",
            plantDescription: "A common garden vegetable",
            spacing: 24,
            daysToMaturity: 80,
            sunRequirement: .fullSun,
            waterRequirement: .moderate,
            plantingDepth: 0.5
        ),
        hardinessZone: "7b"
    )
}
