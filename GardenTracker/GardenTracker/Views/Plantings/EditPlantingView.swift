//
//  EditPlantingView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct EditPlantingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var planting: Planting
    
    @Query private var plants: [Plant]
    
    @State private var selectedPlant: Plant?
    @State private var datePlanted: Date
    @State private var quantity: Int
    @State private var status: PlantingStatus
    @State private var xPosition: Double
    @State private var yPosition: Double
    @State private var expectedHarvestDate: Date?
    
    private var maxX: Double {
        if let gardenBed = planting.gardenBed {
            return gardenBed.width
        } else if let garden = planting.garden {
            return garden.width
        } else {
            return 0
        }
    }
    
    private var maxY: Double {
        if let gardenBed = planting.gardenBed {
            return gardenBed.length
        } else if let garden = planting.garden {
            return garden.length
        } else {
            return 0
        }
    }
    
    init(planting: Planting) {
        self.planting = planting
        _selectedPlant = State(initialValue: planting.plant)
        _datePlanted = State(initialValue: planting.datePlanted)
        _quantity = State(initialValue: planting.quantity)
        _status = State(initialValue: planting.status)
        _xPosition = State(initialValue: planting.xPosition)
        _yPosition = State(initialValue: planting.yPosition)
        _expectedHarvestDate = State(initialValue: planting.expectedHarvestDate)
    }
    
    var body: some View {
        Form {
            Section("Planting Details") {
                Picker("Plant", selection: $selectedPlant) {
                    Text("Select a plant").tag(nil as Plant?)
                    
                    ForEach(plants) { plant in
                        Text(plant.name).tag(plant as Plant?)
                    }
                }
                
                DatePicker("Date Planted", selection: $datePlanted, displayedComponents: .date)
                
                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...100)
                
                Picker("Status", selection: $status) {
                    ForEach(PlantingStatus.allCases, id: \.self) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
                
                // Expected harvest date based on plant's days to maturity
                if let plant = selectedPlant {
                    let estimatedDate = Calendar.current.date(byAdding: .day, value: plant.daysToMaturity, to: datePlanted) ?? Date()
                    
                    Toggle("Set Expected Harvest Date", isOn: Binding(
                        get: { expectedHarvestDate != nil },
                        set: { newValue in
                            expectedHarvestDate = newValue ? estimatedDate : nil
                        }
                    ))
                    
                    if expectedHarvestDate != nil {
                        DatePicker("Expected Harvest", selection: Binding(
                            get: { expectedHarvestDate ?? estimatedDate },
                            set: { expectedHarvestDate = $0 }
                        ), displayedComponents: .date)
                    }
                }
            }
            
            Section("Position") {
                VStack {
                    Text("X Position: \(xPosition.formatted()) ft")
                    Slider(value: $xPosition, in: 0...maxX)
                        .padding(.bottom)
                    
                    Text("Y Position: \(yPosition.formatted()) ft")
                    Slider(value: $yPosition, in: 0...maxY)
                    
                    // Simple position preview
                    ZStack {
                        // Background
                        Rectangle()
                            .fill(Color.brown.opacity(0.3))
                            .frame(width: 200, height: 200)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                        
                        // Plant position
                        Circle()
                            .fill(Color.green)
                            .frame(width: 20, height: 20)
                            .position(
                                x: (xPosition / maxX) * 200,
                                y: (yPosition / maxY) * 200
                            )
                    }
                    .padding(.top)
                    .frame(width: 200, height: 200)
                }
                .padding(.vertical)
            }
            
            Section {
                Button("Save Changes") {
                    planting.plant = selectedPlant
                    planting.datePlanted = datePlanted
                    planting.quantity = quantity
                    planting.status = status
                    planting.xPosition = xPosition
                    planting.yPosition = yPosition
                    planting.expectedHarvestDate = expectedHarvestDate
                    
                    dismiss()
                }
                .disabled(selectedPlant == nil)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Edit Planting")
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
    EditPlantingView(planting: Planting(datePlanted: Date(), quantity: 10, status: .active, xPosition: 0.0, yPosition: 0.0))
}
