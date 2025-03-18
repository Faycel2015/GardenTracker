//
//  CreateTaskView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct CreateTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var garden: Garden?
    
    @Query(sort: \Garden.dateCreated) private var gardens: [Garden]
    @Query private var plantings: [Planting]
    
    @State private var title = ""
    @State private var description = ""
    // Fixed: Using Calendar instead of addingTimeInterval
    @State private var dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())! // Tomorrow
    @State private var type = TaskType.watering
    @State private var isRecurring = false
    @State private var recurrencePattern = RecurrencePattern.weekly
    @State private var selectedGarden: Garden?
    @State private var selectedPlanting: Planting?
    
    var body: some View {
        Form {
            Section("Task Details") {
                TextField("Title", text: $title)
                
                TextField("Description", text: $description, axis: .vertical)
                    .lineLimit(2...6)
                
                DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                
                Picker("Type", selection: $type) {
                    ForEach(TaskType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            }
            
            Section("Location") {
                Picker("Garden", selection: $selectedGarden) {
                    Text("None").tag(nil as Garden?)
                    
                    ForEach(gardens) { garden in
                        Text(garden.name).tag(garden as Garden?)
                    }
                }
                .onAppear {
                    if let garden = garden {
                        selectedGarden = garden
                    }
                }
                
                if selectedGarden != nil {
                    let gardenPlantings = plantings.filter { $0.garden?.id == selectedGarden?.id || $0.gardenBed?.garden?.id == selectedGarden?.id }
                    
                    Picker("Planting", selection: $selectedPlanting) {
                        Text("None").tag(nil as Planting?)
                        
                        ForEach(gardenPlantings) { planting in
                            Text(planting.plant?.name ?? "Unknown Plant").tag(planting as Planting?)
                        }
                    }
                }
            }
            
            Section("Recurrence") {
                Toggle("Recurring Task", isOn: $isRecurring)
                
                if isRecurring {
                    Picker("Repeat", selection: $recurrencePattern) {
                        ForEach(RecurrencePattern.allCases, id: \.self) { pattern in
                            Text(pattern.rawValue).tag(pattern)
                        }
                    }
                }
            }
            
            Section {
                Button("Create Task") {
                    let task = Task(
                        title: title,
                        description: description.isEmpty ? nil : description,
                        dueDate: dueDate,
                        type: type,
                        isRecurring: isRecurring,
                        recurrencePattern: isRecurring ? recurrencePattern : nil
                    )
                    
                    task.garden = selectedGarden
                    task.planting = selectedPlanting
                    
                    modelContext.insert(task)
                    
                    if isRecurring {
                        createRecurringTasks(from: task)
                    }
                    
                    dismiss()
                }
                .disabled(title.isEmpty)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("New Task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
    
    private func createRecurringTasks(from task: Task) {
        // Only create a few instances of recurring tasks to start
        let maxInstances = 5
        var nextDate = task.dueDate
        
        for _ in 0..<maxInstances {
            // Calculate next occurrence
            switch task.recurrencePattern! {
            case .daily:
                nextDate = Calendar.current.date(byAdding: .day, value: 1, to: nextDate)!
            case .weekly:
                nextDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: nextDate)!
            case .biweekly:
                nextDate = Calendar.current.date(byAdding: .weekOfYear, value: 2, to: nextDate)!
            case .monthly:
                nextDate = Calendar.current.date(byAdding: .month, value: 1, to: nextDate)!
            case .custom:
                // For custom, we'll just default to 2 weeks
                nextDate = Calendar.current.date(byAdding: .weekOfYear, value: 2, to: nextDate)!
            }
            
            let recurringTask = Task(
                title: task.title,
                description: task.taskDescription,
                dueDate: nextDate,
                type: task.type,
                isRecurring: true,
                recurrencePattern: task.recurrencePattern
            )
            
            recurringTask.garden = task.garden
            recurringTask.planting = task.planting
            
            modelContext.insert(recurringTask)
        }
    }
}

#Preview {
    CreateTaskView()
}
