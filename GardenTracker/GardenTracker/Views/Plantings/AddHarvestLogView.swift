//
//  AddHarvestLogView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct AddHarvestLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let planting: Planting
    
    @State private var quantity = 1.0
    @State private var unit = HarvestUnit.ounces
    @State private var quality: Int? = 3
    @State private var notes = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        Form {
            Section("Harvest Details") {
                HStack {
                    Text("Quantity")
                    Spacer()
                    TextField("Quantity", value: $quantity, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                }
                
                Picker("Unit", selection: $unit) {
                    ForEach(HarvestUnit.allCases, id: \.self) { unit in
                        Text(unit.rawValue).tag(unit)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Quality")
                    
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Button {
                                quality = star
                            } label: {
                                Image(systemName: quality != nil && star <= quality! ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.title2)
                            }
                        }
                        
                        if quality != nil {
                            Button {
                                quality = nil
                            } label: {
                                Text("Clear")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            .padding(.leading)
                        }
                    }
                }
                
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(3...6)
            }
            
            Section("Photo") {
                if let image = selectedImage {
                    HStack {
                        Spacer()
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                        
                        Spacer()
                    }
                    
                    Button("Remove Photo") {
                        selectedImage = nil
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                } else {
                    Button("Add Photo") {
                        showingImagePicker = true
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            Section {
                Button("Save Harvest") {
                    var imageData: Data?
                    if let image = selectedImage {
                        imageData = image.jpegData(compressionQuality: 0.8)
                    }
                    
                    let log = HarvestLog(
                        quantity: quantity,
                        unit: unit,
                        quality: quality,
                        notes: notes.isEmpty ? nil : notes,
                        imageData: imageData
                    )
                    
                    log.planting = planting
                    modelContext.insert(log)
                    
                    // Update planting status
                    planting.status = .harvested
                    
                    dismiss()
                }
                .disabled(quantity <= 0)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Add Harvest")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

#Preview {
    AddHarvestLogView(planting: Planting(datePlanted: Date(), quantity: 10, status: .active, xPosition: 0.0, yPosition: 0.0))
}
