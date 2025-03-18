//
//  AddPlantNoteView.swift
//  GardenTracker
//
//  Created by FayTek on 3/11/25.
//

import SwiftUI
import SwiftData

struct AddPlantNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let plant: Plant
    
    @State private var content = ""
    @State private var category = NoteCategory.general
    
    var body: some View {
        Form {
            Section("Note") {
                TextEditor(text: $content)
                    .frame(minHeight: 100)
                
                Picker("Category", selection: $category) {
                    ForEach(NoteCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
            }
            
            Section {
                Button("Add Note") {
                    let note = PlantNote(
                        content: content,
                        category: category
                    )
                    
                    note.plant = plant
                    modelContext.insert(note)
                    
                    dismiss()
                }
                .disabled(content.isEmpty)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Add Note")
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
    AddPlantNoteView(plant: Plant(
        name: "Tomato",
        type: "Vegetable",
        plantDescription: "A popular garden vegetable that produces red fruits.",
        spacing: 24.0,
        daysToMaturity: 80,
        sunRequirement: .fullSun,
        waterRequirement: .moderate,
        plantingDepth: 0.25
    ))
}
