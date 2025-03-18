//
//  TaskRowView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct TaskRowView: View {
    let task: Task
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HStack {
            Button {
                task.isCompleted.toggle()
                if task.isCompleted {
                    task.dateCompleted = Date()
                } else {
                    task.dateCompleted = nil
                }
                try? modelContext.save()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
//                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .foregroundColor(task.isCompleted ? AppColors.success : AppColors.textSecondary)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.subheadline)
                    .strikethrough(task.isCompleted)
                
                if let description = task.taskDescription, !description.isEmpty {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(task.dueDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(dueDateColor)
                
                Text(task.type.rawValue)
                    .font(.caption2)
                    .foregroundColor(taskTypeColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(taskTypeColor.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
    }
    
    private var dueDateColor: Color {
        if task.isCompleted {
            return .secondary
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dueDate = calendar.startOfDay(for: task.dueDate)
        
        if today > dueDate {
            return .red
        } else if calendar.isDateInToday(dueDate) {
            return .orange
        } else if let tomorrow = calendar.date(byAdding: .day, value: 1, to: today),
                  calendar.isDate(dueDate, inSameDayAs: tomorrow) {
            return .yellow
        }
        
        return .secondary
    }
    
    private var taskTypeColor: Color {
        switch task.type {
        case .planting:
            return .green
        case .watering:
            return .blue
        case .fertilizing:
            return .brown
        case .pruning:
            return .purple
        case .weeding:
            return .yellow
        case .harvesting:
            return .orange
        case .pestControl:
            return .red
        case .maintenance:
            return .gray
        case .other:
            return .gray
        }
    }
}

#Preview {
    TaskRowView(task: Task(
        title: "Water tomatoes",
        description: "Give them a good soaking",
        dueDate: Date(),
        type: .watering
    ))
}
