//
//  PlantingCalendarView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData
import WeatherKit

struct PlantingCalendarView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Use a simple query without complex predicates
    @Query(sort: \Plant.name) private var plants: [Plant]
    
    @State private var selectedSeason: GrowingSeason = Date().currentGrowingSeason
    @State private var hardinessZone: String = "7b" // Get from user's garden
    
    // Move complex logic to computed properties
    var plantableNow: [Plant] {
        PlantingCalendarService.shared.getPlantsToPlantNow(from: plants, in: hardinessZone)
    }
    
    var plantableBySeason: [GrowingSeason: [Plant]] {
        var result = [GrowingSeason: [Plant]]()
        
        for season in GrowingSeason.allCases {
            let plantable = plants.filter { plant in
                PlantingCalendarService.shared.getSuitablePlantingSeasons(for: plant, in: hardinessZone).contains(season)
            }
            result[season] = plantable
        }
        
        return result
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Current season section
                    VStack(alignment: .leading) {
                        Text("Plant Now")
                            .font(.headline)
                            .padding(.bottom, 4)
                        
                        if plantableNow.isEmpty {
                            Text("No plants recommended for planting right now")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(plantableNow) { plant in
                                        NavigationLink(destination: PlantDetailView(plant: plant)) {
                                            PlantCardView(plant: plant, isRecommended: true)
                                                .frame(width: 160)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Season picker
                    Picker("Season", selection: $selectedSeason) {
                        ForEach([GrowingSeason.spring, .summer, .fall, .winter], id: \.self) { season in
                            Text(season.rawValue).tag(season)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical)
                    
                    // Plants for selected season
                    VStack(alignment: .leading) {
                        Text("Plants for \(selectedSeason.rawValue)")
                            .font(.headline)
                            .padding(.bottom, 4)
                        
                        let seasonPlants = plantableBySeason[selectedSeason] ?? []
                        
                        if seasonPlants.isEmpty {
                            Text("No plants recommended for \(selectedSeason.rawValue)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
                                ForEach(seasonPlants) { plant in
                                    NavigationLink(destination: PlantDetailView(plant: plant)) {
                                        PlantCardView(plant: plant, isRecommended: false)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Planting Calendar")
        }
    }
}

#Preview {
    PlantingCalendarView()
}
