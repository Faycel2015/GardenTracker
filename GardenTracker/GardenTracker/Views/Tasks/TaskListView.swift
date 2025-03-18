//
//  TaskListView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    let garden: Garden
    @Query private var tasks: [Task]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddTask = false
    
    init(garden: Garden) {
        self.garden = garden
        // The _tasks descriptor is automatically generated for the @Query property
        // No need to manually initialize it
    }
    
    var filteredTasks: [Task] {
        if let gardenTasks = garden.tasks {
            return Array(gardenTasks).sorted { $0.dueDate < $1.dueDate }
        }
        return []
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Tasks")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    showingAddTask = true
                } label: {
                    Label("Add Task", systemImage: "plus")
                        .font(.callout)
                }
            }
            
            if filteredTasks.isEmpty {
                Text("No tasks yet")
                    .foregroundColor(.secondary)
                    .padding(.vertical)
            } else {
                ForEach(filteredTasks) { task in
                    TaskRowView(task: task)
                        .swipeActions {
                            Button(role: .destructive) {
                                modelContext.delete(task)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            NavigationStack {
                CreateTaskView(garden: garden)
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
        location: "Backyard"
    )
    
    return TaskListView(garden: garden)
        .modelContainer(container)
}
