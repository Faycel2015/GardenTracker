//
//  PlantRowView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI

struct PlantRowView: View {
    let plant: Plant
    
    var body: some View {
        HStack {
            // Plant icon or image would go here
            Image(systemName: "leaf.fill")
                .foregroundColor(.green)
                .frame(width: 40, height: 40)
                .background(Color.green.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(plant.name)
                    .font(.headline)
                
                Text(plant.type)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                HStack {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.yellow)
                    
                    Text(plant.sunRequirement.rawValue)
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "drop.fill")
                        .foregroundColor(.blue)
                    
                    Text(plant.waterRequirement.rawValue)
                        .font(.caption)
                }
            }
        }
    }
}

#Preview {
    PlantRowView(plant: Plant(
        name: "Tomato",
        type: "Vegetable",
        plantDescription: "A red garden fruit commonly used in salads and sauces.",
        spacing: 24.0,
        daysToMaturity: 80,
        sunRequirement: .fullSun,
        waterRequirement: .moderate,
        plantingDepth: 0.25
    ))
}
