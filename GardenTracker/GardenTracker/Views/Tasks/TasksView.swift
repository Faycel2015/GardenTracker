//
//  TasksView.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftData
import SwiftUI

struct TasksView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Replace complex Query with manual fetching
    @State private var tasks: [Task] = []
    
    // Use a simple query instead
    @Query private var allTasks: [Task]

    @State private var showingAddTask = false
    @State private var selectedFilter: TaskFilter = .all
    @State private var selectedSortOption: TaskSortOption = .dueDate

    enum TaskFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case upcoming = "Upcoming"
        case today = "Today"
        case completed = "Completed"
        case overdue = "Overdue"

        var id: String { rawValue }
    }

    enum TaskSortOption: String, CaseIterable, Identifiable {
        case dueDate = "Due Date"
        case creationDate = "Creation Date"
        case taskType = "Task Type"
        case garden = "Garden"

        var id: String { rawValue }
    }

    var filteredTasks: [Task] {
        // Use the pre-fetched tasks
        if selectedFilter == .all {
            return tasks
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        switch selectedFilter {
        case .all:
            return tasks
        case .upcoming:
            return tasks.filter { !$0.isCompleted && $0.dueDate >= today }
        case .today:
            return tasks.filter { calendar.isDateInToday($0.dueDate) }
        case .completed:
            return tasks.filter { $0.isCompleted }
        case .overdue:
            return tasks.filter { !$0.isCompleted && $0.dueDate < today }
        }
    }

    var groupedTasks: [String: [Task]] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let nextWeek = calendar.date(byAdding: .day, value: 7, to: today)!

        var result = [String: [Task]]()

        if selectedFilter == .all || selectedFilter == .upcoming {
            // Group by time period
            let overdueItems = filteredTasks.filter { !$0.isCompleted && $0.dueDate < today }
            let todayItems = filteredTasks.filter { calendar.isDateInToday($0.dueDate) }
            let tomorrowItems = filteredTasks.filter { calendar.isDate($0.dueDate, inSameDayAs: tomorrow) }
            let thisWeekItems = filteredTasks.filter {
                let date = $0.dueDate
                return date > tomorrow && date < nextWeek
            }
            let laterItems = filteredTasks.filter { $0.dueDate >= nextWeek }

            if !overdueItems.isEmpty { result["Overdue"] = overdueItems }
            if !todayItems.isEmpty { result["Today"] = todayItems }
            if !tomorrowItems.isEmpty { result["Tomorrow"] = tomorrowItems }
            if !thisWeekItems.isEmpty { result["This Week"] = thisWeekItems }
            if !laterItems.isEmpty { result["Later"] = laterItems }
        } else if selectedFilter == .completed {
            // Group completed tasks by completion date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"

            let grouped = Dictionary(grouping: filteredTasks) { task in
                if let date = task.dateCompleted {
                    return dateFormatter.string(from: date)
                }
                return "Unknown Date"
            }

            for (key, value) in grouped {
                result[key] = value
            }
        } else {
            // Just use the filter name
            result[selectedFilter.rawValue] = filteredTasks
        }

        return result
    }

    var sortedGroupKeys: [String] {
        let keys = Array(groupedTasks.keys)

        // Custom sort order for time periods
        let keyOrder = ["Overdue", "Today", "Tomorrow", "This Week", "Later"]

        return keys.sorted { key1, key2 in
            if keyOrder.contains(key1) && keyOrder.contains(key2) {
                return keyOrder.firstIndex(of: key1)! < keyOrder.firstIndex(of: key2)!
            } else if keyOrder.contains(key1) {
                return true
            } else if keyOrder.contains(key2) {
                return false
            } else {
                return key1 > key2 // For dates, show more recent first
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Filter pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(TaskFilter.allCases) { filter in
                            FilterPill(title: filter.rawValue, isSelected: selectedFilter == filter) {
                                selectedFilter = filter
                                updateTasks()
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Sort option
                Menu {
                    ForEach(TaskSortOption.allCases) { option in
                        Button {
                            selectedSortOption = option
                            updateTasks()
                        } label: {
                            if selectedSortOption == option {
                                Label(option.rawValue, systemImage: "checkmark")
                            } else {
                                Text(option.rawValue)
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text("Sort by: \(selectedSortOption.rawValue)")
                            .font(.caption)

                        Image(systemName: "arrow.up.arrow.down")
                            .font(.caption)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray5))
                    .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)

                List {
                    if allTasks.isEmpty {
                        ContentUnavailableView(
                            "No Tasks",
                            systemImage: "checklist",
                            description: Text("Tap the + button to create your first task")
                        )
                    } else if filteredTasks.isEmpty {
                        ContentUnavailableView(
                            "No Tasks",
                            systemImage: "checklist",
                            description: Text("No tasks matching the current filter")
                        )
                    } else {
                        ForEach(sortedGroupKeys, id: \.self) { key in
                            if let tasks = groupedTasks[key] {
                                Section(key) {
                                    ForEach(tasks) { task in
                                        TaskRowView(task: task)
                                            .swipeActions {
                                                Button(role: .destructive) {
                                                    modelContext.delete(task)
                                                    updateTasks()
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                NavigationStack {
                    CreateTaskView()
                }
            }
            .task {
                // Fetch tasks when view appears
                updateTasks()
            }
            .refreshable {
                updateTasks()
            }
        }
    }
    
    private func updateTasks() {
        // Sort tasks based on selected option
        var sortDescriptors: [SortDescriptor<Task>] = []
        
        switch selectedSortOption {
        case .dueDate:
            sortDescriptors = [SortDescriptor(\Task.dueDate)]
        case .creationDate:
            sortDescriptors = [SortDescriptor(\Task.dateCreated, order: .reverse)]
        case .taskType:
            sortDescriptors = [SortDescriptor(\Task.type.rawValue)]
        case .garden:
            // Can't sort directly by garden name, so we'll sort later in code
            sortDescriptors = [SortDescriptor(\Task.dueDate)]
        }
        
        // Create fetch descriptor with appropriate sort
        let fetchDescriptor = FetchDescriptor<Task>(sortBy: sortDescriptors)
        
        do {
            // Fetch all tasks
            tasks = try modelContext.fetch(fetchDescriptor)
            
            // Apply garden name sorting if needed
            if selectedSortOption == .garden {
                tasks.sort { ($0.garden?.name ?? "") < ($1.garden?.name ?? "") }
            }
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }
}

#Preview {
    TasksView()
}
