//
//  DashboardView.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import MapKit
import SwiftData
import SwiftUI
import WeatherKit

// MARK: - Dashboard View

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
   
    // Replace @Query with State for manual fetching
    @State private var gardens: [Garden] = []
    @State private var upcomingTasks: [Task] = []
    @State private var weatherData: [WeatherData] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil

    let weatherService = WeatherService.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                if isLoading {
                    ProgressView("Loading dashboard...")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 40)
                } else if let error = errorMessage {
                    ContentUnavailableView("Error Loading Data",
                                           systemImage: "exclamationmark.triangle",
                                           description: Text(error))
                } else {
                    dashboardContent
                }
            }
            .navigationTitle("Garden Dashboard")
            .background(AppColors.background.ignoresSafeArea())
            .task {
                isLoading = true
                await loadData()
                isLoading = false
            }
            .refreshable {
                errorMessage = nil
                await loadData()
            }
        }
    }

    // Extracted dashboard content for better readability
    private var dashboardContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Weather Summary
            if let currentWeather = weatherData.first {
                WeatherSummaryView(weatherData: currentWeather)
            } else {
                WeatherSummaryPlaceholder()
            }

            // Planting Recommendations
            PlantingRecommendationsWidget(
                hardinessZone: gardens.first?.hardinessZone ?? "7b"
            )

            // Upcoming Tasks
            TaskSummaryView(tasks: upcomingTasks)
                .contentTransition(.opacity)

            // Garden Overview
            GardenSummaryView(gardens: gardens)
                .contentTransition(.opacity)

            // Harvest Log Summary
            HarvestSummaryView()
        }
        .padding()
        .animation(.easeInOut, value: upcomingTasks.count)
        .animation(.easeInOut, value: gardens.count)
    }

    // Combined loading function for better error handling
    private func loadData() async {
        do {
            // Load data in parallel when possible
            async let weather: () = fetchWeatherData()
            let _: () = fetchUpcomingTasks()

            // Also fetch gardens manually
            await fetchGardens()

            // Wait for async weather data to load
            _ = try await weather
        } catch {
            errorMessage = "Could not load dashboard data: \(error.localizedDescription)"
        }
    }

    private func fetchWeatherData() async throws {
        // This would use WeatherKit to fetch actual weather data
        // In a real app, add error handling here
        // For now, populate with sample data
        weatherData = [
            WeatherData(
                temperature: 72.5,
                conditions: "Partly Cloudy",
                precipitation: 0.1,
                humidity: 65.0,
                windSpeed: 5.0,
                date: Date()
            ),
        ]
    }

    private func fetchUpcomingTasks() {
        // Ensure the future date is computed before using it
        guard let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: Date()) else {
            errorMessage = "Error calculating next week's date."
            return
        }

        do {
            // Create a manual fetch descriptor
            let fetchDescriptor = FetchDescriptor<Task>(
                predicate: #Predicate<Task> { task in
                    !task.isCompleted && task.dueDate <= nextWeek
                },
                sortBy: [SortDescriptor(\.dueDate, order: .forward)]
            )

            // Fetch tasks manually
            upcomingTasks = try modelContext.fetch(fetchDescriptor)
        } catch {
            errorMessage = "Error fetching tasks: \(error.localizedDescription)"
        }
    }

    // Add a new function for fetching gardens
    private func fetchGardens() async {
        do {
            let descriptor = FetchDescriptor<Garden>(sortBy: [SortDescriptor(\.dateCreated)])
            gardens = try modelContext.fetch(descriptor)
        } catch {
            errorMessage = "Error fetching gardens: \(error.localizedDescription)"
        }
    }
}

// MARK: - Preview

#Preview {
    do {
        // Create a schema with all required model types
        let schema = Schema([
            Garden.self,
            Plant.self,
            GardenBed.self,
            Planting.self,
            Task.self,
            GrowthLog.self,
            HarvestLog.self,
            PlantNote.self,
            CropRotation.self,
        ])

        // Use in-memory configuration
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])

        // Add some sample data for preview
//        let _ = container.mainContext
        // You could add sample data here

        return DashboardView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
