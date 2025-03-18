//
//  PlantCardView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI

struct PlantCardView: View {
    let plant: Plant
    let isRecommended: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            // Plant icon or image
            Image(systemName: "leaf.fill")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color.green.gradient)
                .clipShape(Circle())
            
            Text(plant.name)
                .font(.headline)
                .lineLimit(1)
            
            Text(plant.type)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            if isRecommended {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppColors.success)
                    Text("Plant now")
                        .font(.caption)
                        .foregroundColor(AppColors.success)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

#Preview {
    let plant = Plant(
        name: "Tomato",
        type: "Vegetable",
        plantDescription: "A juicy red fruit commonly used in salads and cooking",
        spacing: 24,
        daysToMaturity: 80,
        sunRequirement: .fullSun,
        waterRequirement: .moderate,
        plantingDepth: 0.5,
        companionPlants: ["Basil", "Marigold"],
        adversaryPlants: ["Potato", "Fennel"],
        growingSeasons: [.summer]
    )
    
    return PlantCardView(plant: plant, isRecommended: true)
}
