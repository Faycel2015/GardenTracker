//
//  PlantingRecommendationsWidget.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct PlantingRecommendationsWidget: View {
    @Query private var plants: [Plant]
    let hardinessZone: String
    
    init(hardinessZone: String) {
        self.hardinessZone = hardinessZone
        // No need to modify the @Query here as it's already initialized
    }
    
    var plantableNow: [Plant] {
        PlantingCalendarService.shared.getPlantsToPlantNow(from: plants, in: hardinessZone)
            .prefix(3) // Limit to 3 for the widget
            .map { $0 }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Planting Recommendations")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink(destination: PlantingCalendarView()) {
                    Text("See All")
                        .font(.caption)
                }
            }
            
            if plantableNow.isEmpty {
                Text("No plants to plant right now")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical)
            } else {
                ForEach(plantableNow) { plant in
                    NavigationLink(destination: PlantDetailView(plant: plant)) {
                        HStack {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.green)
                                .frame(width: 30, height: 30)
                                .background(Color.green.opacity(0.2))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text(plant.name)
                                    .font(.subheadline)
                                
                                Text("Good time to plant!")
                                    .font(.caption)
                                    .foregroundColor(AppColors.success)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            
            // Show current season
            let currentSeason = Date().currentGrowingSeason
            HStack {
                Text("Current growing season: \(currentSeason.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Days left in season
                let daysLeft = daysLeftInCurrentSeason()
                Text("\(daysLeft) days left")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
    
    private func daysLeftInCurrentSeason() -> Int {
        let currentSeason = Date().currentGrowingSeason
        let currentYear = Date().year
        
        var endDate: Date
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = currentYear
        
        switch currentSeason {
        case .spring:
            components.month = 6
            components.day = 20
        case .summer:
            components.month = 9
            components.day = 21
        case .fall:
            components.month = 12
            components.day = 20
        case .winter:
            components.year = currentYear + 1
            components.month = 3
            components.day = 19
        case .yearRound:
            components.month = 12
            components.day = 31
        }
        
        endDate = calendar.date(from: components)!
        return Date().daysSince(endDate) * -1
    }
}

// Preview wrapper to prepare SwiftData container and provide a hardiness zone
#Preview {
    PlantingRecommendationsWidget(hardinessZone: "7b")
        .modelContainer(for: [Plant.self], inMemory: true)
}
