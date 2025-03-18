//
//  TaskSummaryView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct TaskSummaryView: View {
    let tasks: [Task]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Upcoming Tasks")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink(destination: TasksView()) {
                    Text("See All")
                        .font(.caption)
                }
            }
            
            if tasks.isEmpty {
                Text("No upcoming tasks")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical)
            } else {
                ForEach(tasks.prefix(3)) { task in
                    TaskRowView(task: task)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

// Sample tasks for preview
extension Task {
    static var sampleTasks: [Task] {
        // Fixed: Using Calendar.date(byAdding:) instead of addingTimeInterval
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let dayAfterTomorrow = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        
        return [
            Task(title: "Water tomatoes", dueDate: tomorrow, type: .watering),
            Task(title: "Harvest lettuce", dueDate: dayAfterTomorrow, type: .harvesting)
        ]
    }
}

#Preview {
    TaskSummaryView(tasks: Task.sampleTasks)
}
