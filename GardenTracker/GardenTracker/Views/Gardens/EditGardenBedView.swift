//
//  EditGardenBedView.swift
//  GardenTracker
//
//  Created by FayTek on 3/11/25.
//

import SwiftUI
import SwiftData

// MARK: - Edit Garden Bed View
struct EditGardenBedView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var gardenBed: GardenBed
    
    @State private var name: String
    @State private var width: Double
    @State private var length: Double
    @State private var xPosition: Double
    @State private var yPosition: Double
    @State private var soilType: String
    
    private var maxX: Double {
        if let garden = gardenBed.garden {
            return garden.width - width
        }
        return 0
    }
    
    private var maxY: Double {
        if let garden = gardenBed.garden {
            return garden.length - length
        }
        return 0
    }
    
    init(gardenBed: GardenBed) {
        self.gardenBed = gardenBed
        _name = State(initialValue: gardenBed.name)
        _width = State(initialValue: gardenBed.width)
        _length = State(initialValue: gardenBed.length)
        _xPosition = State(initialValue: gardenBed.xPosition)
        _yPosition = State(initialValue: gardenBed.yPosition)
        _soilType = State(initialValue: gardenBed.soilType ?? "")
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
                            if let garden = gardenBed.garden, width > garden.width {
                                width = garden.width
                            }
                            
                            if xPosition + width > (gardenBed.garden?.width ?? 0) {
                                xPosition = (gardenBed.garden?.width ?? 0) - width
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
                            if let garden = gardenBed.garden, length > garden.length {
                                length = garden.length
                            }
                            
                            if yPosition + length > (gardenBed.garden?.length ?? 0) {
                                yPosition = (gardenBed.garden?.length ?? 0) - length
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
                    if let garden = gardenBed.garden {
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
                }
                .padding(.vertical)
            }
            
            Section("Optional Information") {
                TextField("Soil Type", text: $soilType)
            }
            
            Section {
                Button("Save Changes") {
                    gardenBed.name = name
                    gardenBed.width = width
                    gardenBed.length = length
                    gardenBed.xPosition = xPosition
                    gardenBed.yPosition = yPosition
                    gardenBed.soilType = soilType.isEmpty ? nil : soilType
                    
                    dismiss()
                }
                .disabled(name.isEmpty || width <= 0 || length <= 0)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Edit Garden Bed")
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

// MARK: - Add Crop Rotation View

struct AddCropRotationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let gardenBed: GardenBed
    
    @State private var year = Calendar.current.component(.year, from: Date())
    @State private var season = GrowingSeason.spring
    @State private var cropFamily = ""
    
    var body: some View {
        Form {
            Section("Crop Rotation Entry") {
                Stepper("Year: \(year)", value: $year, in: 2000...2100)
                
                Picker("Season", selection: $season) {
                    ForEach(GrowingSeason.allCases, id: \.self) { season in
                        Text(season.rawValue).tag(season)
                    }
                }
                
                TextField("Crop Family", text: $cropFamily)
            }
            
            Section {
                Button("Add Entry") {
                    let rotation = CropRotation(
                        year: year,
                        season: season,
                        cropFamily: cropFamily
                    )
                    
                    rotation.gardenBed = gardenBed
                    modelContext.insert(rotation)
                    
                    dismiss()
                }
                .disabled(cropFamily.isEmpty)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Add Crop Rotation")
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
    let container = try! ModelContainer(for: GardenBed.self, configurations: config)
    
    // Create a garden
    let garden = Garden(
        name: "Test Garden",
        width: 20.0,
        length: 30.0
    )
    
    // Create a garden bed with the garden as parent
    let gardenBed = GardenBed(
        name: "Test Bed",
        width: 4.0,
        length: 8.0,
        xPosition: 2.0,
        yPosition: 3.0,
        soilType: "Loamy"
    )
    gardenBed.garden = garden
    
    return NavigationStack {
        EditGardenBedView(gardenBed: gardenBed)
            .modelContainer(container)
    }
}
