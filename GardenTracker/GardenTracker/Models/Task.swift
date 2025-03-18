//
//  Task.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

// MARK: - Task Model
@Model
final class Task {
    var title: String
    var taskDescription: String?
    var dueDate: Date
    var isCompleted: Bool
    var type: TaskType
    var isRecurring: Bool
    var recurrencePattern: RecurrencePattern?
    var dateCreated: Date
    var dateCompleted: Date?
    
    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \Garden.tasks) var garden: Garden?
    @Relationship(deleteRule: .noAction) var planting: Planting?
    
    init(
        title: String,
        description: String? = nil,  // Note: Parameter name is "description"
        dueDate: Date,
        isCompleted: Bool = false,
        type: TaskType,
        isRecurring: Bool = false,
        recurrencePattern: RecurrencePattern? = nil,
        dateCreated: Date = Date(),
        dateCompleted: Date? = nil
    ) {
        self.title = title
        self.taskDescription = description  // But property name is "taskDescription"
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.type = type
        self.isRecurring = isRecurring
        self.recurrencePattern = recurrencePattern
        self.dateCreated = dateCreated
        self.dateCompleted = dateCompleted
    }
}
