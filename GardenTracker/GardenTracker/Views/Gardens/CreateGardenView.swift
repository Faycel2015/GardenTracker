//
//  CreateGardenView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

// MARK: - Create Garden View

struct CreateGardenView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var width: Double = 10
    @State private var length: Double = 20
    @State private var location = ""
    @State private var soilType = ""
    @State private var hardinessZone = ""
    
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
                Button("Create Garden") {
                    let garden = Garden(
                        name: name,
                        width: width,
                        length: length,
                        location: location.isEmpty ? nil : location,
                        soilType: soilType.isEmpty ? nil : soilType,
                        hardinessZone: hardinessZone.isEmpty ? nil : hardinessZone
                    )
                    
                    modelContext.insert(garden)
                    dismiss()
                }
                .disabled(name.isEmpty || width <= 0 || length <= 0)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("New Garden")
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
    CreateGardenView()
}
