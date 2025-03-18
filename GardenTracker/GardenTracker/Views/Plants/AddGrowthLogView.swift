//
//  AddGrowthLogView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct AddGrowthLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let plant: Plant
    
    @State private var notes = ""
    @State private var stage: GrowthStage?
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        Form {
            Section("Growth Log Entry") {
                TextEditor(text: $notes)
                    .frame(minHeight: 100)
                
                Picker("Growth Stage", selection: $stage) {
                    Text("None").tag(nil as GrowthStage?)
                    ForEach(plant.growthStages, id: \.self) { stage in
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
                    
                    log.plant = plant
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
    AddGrowthLogView(plant: Plant(
        name: "Tomato",
        type: "Vegetable",
        plantDescription: "A popular garden vegetable that produces red fruits.",
        spacing: 24.0,
        daysToMaturity: 80,
        sunRequirement: .fullSun,
        waterRequirement: .moderate,
        plantingDepth: 0.25,
        growthStages: [.seed, .seedling, .vegetative, .flowering, .fruiting, .harvest])
    )
}
