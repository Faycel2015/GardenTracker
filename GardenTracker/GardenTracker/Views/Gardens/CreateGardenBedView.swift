//
//  CreateGardenBedView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

// MARK: - Garden Bed Views
struct CreateGardenBedView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let garden: Garden
    
    @State private var name = ""
    @State private var width: Double = 4
    @State private var length: Double = 8
    @State private var xPosition: Double = 0
    @State private var yPosition: Double = 0
    @State private var soilType = ""
    
    private var maxX: Double {
        garden.width - width
    }
    
    private var maxY: Double {
        garden.length - length
    }
    
    var body: some View {
        Form {
            Section("Bed Details") {
                TextField("Bed Name", text: $name)
                
                HStack {
                    Text("Width (feet)")
                    Spacer()
                    TextField("Width", value: $width, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                        .onChange(of: width) {
                            if width > garden.width {
                                width = garden.width
                            }
                            
                            if xPosition + width > garden.width {
                                xPosition = garden.width - width
                            }
                        }
                }
                
                HStack {
                    Text("Length (feet)")
                    Spacer()
                    TextField("Length", value: $length, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                        .onChange(of: length) {
                            if length > garden.length {
                                length = garden.length
                            }
                            
                            if yPosition + length > garden.length {
                                yPosition = garden.length - length
                            }
                        }
                }
            }
            
            Section("Position") {
                VStack {
                    Text("X Position: \(xPosition.formatted()) ft")
                    Slider(value: $xPosition, in: 0...max(0, maxX))
                        .padding(.bottom)
                    
                    Text("Y Position: \(yPosition.formatted()) ft")
                    Slider(value: $yPosition, in: 0...max(0, maxY))
                    
                    // Simple position preview
                    ZStack {
                        // Garden background
                        Rectangle()
                            .fill(Color.brown.opacity(0.3))
                            .frame(width: 200, height: 200)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                        
                        // Garden bed
                        let bedWidth = (width / garden.width) * 200
                        let bedHeight = (length / garden.length) * 200
                        let posX = (xPosition / garden.width) * 200
                        let posY = (yPosition / garden.length) * 200
                        
                        Rectangle()
                            .fill(Color.brown.opacity(0.7))
                            .frame(width: bedWidth, height: bedHeight)
                            .position(x: posX + (bedWidth / 2), y: posY + (bedHeight / 2))
                    }
                    .padding(.top)
                    .frame(width: 200, height: 200)
                }
                .padding(.vertical)
            }
            
            Section("Optional Information") {
                TextField("Soil Type", text: $soilType)
            }
            
            Section {
                Button("Create Bed") {
                    let bed = GardenBed(
                        name: name,
                        width: width,
                        length: length,
                        xPosition: xPosition,
                        yPosition: yPosition,
                        soilType: soilType.isEmpty ? nil : soilType
                    )
                    
                    bed.garden = garden
                    modelContext.insert(bed)
                    
                    dismiss()
                }
                .disabled(name.isEmpty || width <= 0 || length <= 0)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("New Garden Bed")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Garden.self, configurations: config)
    
    let garden = Garden(
        name: "Sample Garden",
        width: 20.0,
        length: 30.0,
        location: "Backyard",
        soilType: "Loam",
        hardinessZone: "7b"
    )
    
    return NavigationStack {
        CreateGardenBedView(garden: garden)
            .modelContainer(container)
    }
}
