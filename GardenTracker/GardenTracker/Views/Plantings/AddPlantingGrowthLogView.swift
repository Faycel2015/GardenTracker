//
//  AddPlantingGrowthLogView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct AddPlantingGrowthLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let planting: Planting
    
    @State private var notes = ""
    @State private var stage: GrowthStage?
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    var growthStages: [GrowthStage] {
        if let plant = planting.plant {
            return plant.growthStages
        }
        return GrowthStage.allCases
    }
    
    var body: some View {
        Form {
            Section("Growth Log Entry") {
                TextEditor(text: $notes)
                    .frame(minHeight: 100)
                
                Picker("Growth Stage", selection: $stage) {
                    Text("None").tag(nil as GrowthStage?)
                    ForEach(growthStages, id: \.self) { stage in
                        Text(stage.rawValue).tag(stage as GrowthStage?)
                    }
                }
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
                Button("Save Log Entry") {
                    var imageData: Data?
                    if let image = selectedImage {
                        imageData = image.jpegData(compressionQuality: 0.8)
                    }
                    
                    let log = GrowthLog(
                        notes: notes.isEmpty ? nil : notes,
                        stage: stage,
                        imageData: imageData
                    )
                    
                    log.planting = planting
                    if let plant = planting.plant {
                        log.plant = plant
                    }
                    
                    modelContext.insert(log)
                    
                    dismiss()
                }
                .disabled(notes.isEmpty && stage == nil && selectedImage == nil)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Add Growth Log")
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
    AddPlantingGrowthLogView(planting: Planting(datePlanted: Date(), quantity: 10, status: .active, xPosition: 0.0, yPosition: 0.0))
}
