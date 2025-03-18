//
//  PlantingDotView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct PlantingDotView: View {
    let planting: Planting
    let gardenWidth: Double
    let gardenLength: Double
    
    var body: some View {
        let relativeX = (planting.xPosition / gardenWidth) * 2 - 1
        let relativeY = (planting.yPosition / gardenLength) * 2 - 1
        
        Circle()
            .fill(plantingColor)
            .frame(width: 10, height: 10)
            .position(
                x: relativeX * (UIScreen.main.bounds.width / 2),
                y: relativeY * (UIScreen.main.bounds.height / 2)
            )
    }
    
    private var plantingColor: Color {
        switch planting.status {
        case .planned:
            return .gray
        case .active:
            return .green
        case .harvested:
            return .brown
        case .failed:
            return .red
        case .removed:
            return .black
        }
    }
}

// Sample planting for preview
extension Planting {
    static var samplePlanting: Planting {
        Planting(
            datePlanted: Date(),
            quantity: 3,
            status: .active,
            xPosition: 5.0,
            yPosition: 7.0
        )
    }
}

#Preview {
    PlantingDotView(
        planting: Planting.samplePlanting,
        gardenWidth: 20.0,
        gardenLength: 30.0
    )
}
