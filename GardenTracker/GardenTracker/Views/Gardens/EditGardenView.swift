//
//  EditGardenView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

// MARK: - Edit Garden View

struct EditGardenView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var garden: Garden
    
    @State private var name: String
    @State private var width: Double
    @State private var length: Double
    @State private var location: String
    @State private var soilType: String
    @State private var hardinessZone: String
    
    init(garden: Garden) {
        self.garden = garden
        _name = State(initialValue: garden.name)
        _width = State(initialValue: garden.width)
        _length = State(initialValue: garden.length)
        _location = State(initialValue: garden.location ?? "")
        _soilType = State(initialValue: garden.soilType ?? "")
        _hardinessZone = State(initialValue: garden.hardinessZone ?? "")
    }
    
    var body: some View {
        Form {
            Section("Garden Details") {
                TextField("Garden Name", text: $name)
                
                HStack {
                    Text("Width (feet)")
                    Spacer()
                    TextField("Width", value: $width, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                }
                
                HStack {
                    Text("Length (feet)")
                    Spacer()
                    TextField("Length", value: $length, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                }
            }
            
            Section("Optional Information") {
                TextField("Location", text: $location)
                TextField("Soil Type", text: $soilType)
                TextField("Hardiness Zone", text: $hardinessZone)
            }
            
            Section {
                Button("Save Changes") {
                    garden.name = name
                    garden.width = width
                    garden.length = length
                    garden.location = location.isEmpty ? nil : location
                    garden.soilType = soilType.isEmpty ? nil : soilType
                    garden.hardinessZone = hardinessZone.isEmpty ? nil : hardinessZone
                    
                    dismiss()
                }
                .disabled(name.isEmpty || width <= 0 || length <= 0)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Edit Garden")
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
        EditGardenView(garden: garden)
            .modelContainer(container)
    }
}
