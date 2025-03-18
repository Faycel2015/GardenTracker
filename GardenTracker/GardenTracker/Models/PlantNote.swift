//
//  PlantNote.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

// MARK: - PlantNote Model
@Model
final class PlantNote {
    var date: Date
    var content: String
    var category: NoteCategory
    
    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \Plant.notes) var plant: Plant?
    
    init(
        date: Date = Date(),
        content: String,
        category: NoteCategory = .general
    ) {
        self.date = date
        self.content = content
        self.category = category
    }
}
