//
//  GardenBedCardView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct GardenBedCardView: View {
    let gardenBed: GardenBed
    
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .fill(Color.brown.opacity(0.6))
                .frame(height: 80)
                .overlay(
                    Text(gardenBed.name)
                        .font(.headline)
                        .foregroundColor(.white)
                )
            
            Text("\(gardenBed.width.formatted())' × \(gardenBed.length.formatted())'")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("\(gardenBed.plantings?.count ?? 0) plants")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

// Sample garden bed for preview
extension GardenBed {
    static var sampleBed: GardenBed {
        GardenBed(
            name: "Vegetable Bed",
            width: 4.0,
            length: 8.0,
            xPosition: 2.0,
            yPosition: 3.0,
            soilType: "Loamy"
        )
    }
}

#Preview {
    GardenBedCardView(gardenBed: GardenBed.sampleBed)
}
