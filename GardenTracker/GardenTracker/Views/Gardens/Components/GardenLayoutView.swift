//
//  GardenLayoutView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

// MARK: - Garden Layout View

struct GardenLayoutView: View {
    let garden: Garden
    
    var body: some View {
        ZStack {
            // Garden background
            Rectangle()
                .fill(Color.brown.opacity(0.3))
            
            // Grid lines
            GardenGridView(width: garden.width, length: garden.length)
            
            // Garden beds
            if let beds = garden.beds {
                ForEach(beds) { bed in
                    GardenBedShapeView(gardenBed: bed, gardenWidth: garden.width, gardenLength: garden.length)
                }
            }
            
            // Plantings (directly in garden, not in beds)
            if let plantings = garden.plantings {
                ForEach(plantings) { planting in
                    PlantingDotView(planting: planting, gardenWidth: garden.width, gardenLength: garden.length)
                }
            }
        }
    }
}

// MARK: - Garden Grid View

struct GardenGridView: View {
    let width: Double
    let length: Double
    let gridSize: Double = 1.0 // 1 foot grid
    
    var body: some View {
        ZStack {
            // Vertical lines
            ForEach(0..<Int(width + 1), id: \.self) { i in
                let x = (Double(i) / width) * 2 - 1
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 1)
                    .position(x: x * (UIScreen.main.bounds.width / 2), y: 0)
                    .frame(width: 1, height: UIScreen.main.bounds.height)
            }
            
            // Horizontal lines
            ForEach(0..<Int(length + 1), id: \.self) { i in
                let y = (Double(i) / length) * 2 - 1
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                    .position(x: 0, y: y * (UIScreen.main.bounds.height / 2))
                    .frame(width: UIScreen.main.bounds.width, height: 1)
            }
        }
    }
}

// MARK: - Garden Bed Shape View

struct GardenBedShapeView: View {
    let gardenBed: GardenBed
    let gardenWidth: Double
    let gardenLength: Double
    
    var body: some View {
        let relativeX = (gardenBed.xPosition / gardenWidth) * 2 - 1 + (gardenBed.width / gardenWidth)
        let relativeY = (gardenBed.yPosition / gardenLength) * 2 - 1 + (gardenBed.length / gardenLength)
        let relativeWidth = (gardenBed.width / gardenWidth) * 2
        let relativeLength = (gardenBed.length / gardenLength) * 2
        
        Rectangle()
            .fill(Color.brown.opacity(0.6))
            .frame(
                width: relativeWidth * (UIScreen.main.bounds.width / 2),
                height: relativeLength * (UIScreen.main.bounds.height / 2)
            )
            .position(
                x: relativeX * (UIScreen.main.bounds.width / 2),
                y: relativeY * (UIScreen.main.bounds.height / 2)
            )
            .overlay(
                Text(gardenBed.name)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color.black.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            )
    }
}

// Sample garden for preview
extension Garden {
    static var sampleGarden: Garden {
        let garden = Garden(
            name: "Backyard Garden",
            width: 20.0,
            length: 30.0,
            location: "Backyard",
            soilType: "Loam",
            hardinessZone: "7b"
        )
        
        // Add some beds if needed
        // let bed = GardenBed(name: "Veggie Bed", width: 4, length: 8, xPosition: 2, yPosition: 3)
        // bed.garden = garden
        // garden.beds = [bed]
        
        return garden
    }
}

#Preview {
    GardenLayoutView(garden: Garden.sampleGarden)
}
