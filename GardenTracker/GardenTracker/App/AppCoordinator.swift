//
//  AppCoordinator.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import Foundation
import SwiftData
import UIKit
import Combine

/// Coordinator that handles app initialization and global app state
class AppCoordinator: ObservableObject {
    static let shared = AppCoordinator()
    
    @Published var themeManager = ThemeManager.shared
    @Published var hasCompletedOnboarding = false
    @Published var isFirstLaunch = true
    
    private init() {
        // Load saved state
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    }
    
    /// Initialize the app on first launch
    /// - Parameter modelContext: The model context
    func initializeApp(with modelContext: ModelContext) {
        // If this is the first launch, create sample data
        if isFirstLaunch {
            // Create sample data
            SampleDataProvider.shared.createSampleData(in: modelContext)
            
            // Mark that the app has been launched before
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            isFirstLaunch = false
            // Initialize theme from user preferences if needed
            _ = themeManager
        }
    }
    
    /// Complete the onboarding process
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
    
    /// Reset the app to first launch state (for development/testing)
    func resetAppState() {
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(false, forKey: "hasLaunchedBefore")
        hasCompletedOnboarding = false
        isFirstLaunch = true
    }
    
    /// Perform maintenance tasks such as checking for overdue tasks
    /// - Parameter modelContext: The model context
    func performMaintenance(with modelContext: ModelContext) {
        // Check for and notify about overdue tasks
        checkForOverdueTasks(with: modelContext)
        
        // Check for plants that need watering
        checkForWateringNeeds(with: modelContext)
        
        // Update harvest predictions
        updateHarvestPredictions(with: modelContext)
    }
    
    /// Check for overdue tasks and send notifications
    /// - Parameter modelContext: The model context
    private func checkForOverdueTasks(with modelContext: ModelContext) {
        // Pre-calculate the date for the predicate
        let today = Date()
        
        let taskFetchDescriptor = FetchDescriptor<Task>(
            predicate: #Predicate<Task> {
                !$0.isCompleted && $0.dueDate < today
            }
        )
        
        guard let overdueTasks = try? modelContext.fetch(taskFetchDescriptor) else {
            return
        }
        
        if !overdueTasks.isEmpty {
            // In a real app, would send a notification here
            print("Found \(overdueTasks.count) overdue tasks")
        }
    }
    
    /// Check which plants likely need watering
    /// - Parameter modelContext: The model context
    private func checkForWateringNeeds(with modelContext: ModelContext) {
        // Need to use raw value comparison for enum in SwiftData predicates
        let activeStatus = PlantingStatus.active.rawValue
        
        let plantingFetchDescriptor = FetchDescriptor<Planting>(
            predicate: #Predicate<Planting> {
                $0.status.rawValue == activeStatus
            }
        )
        
        guard let activePlantings = try? modelContext.fetch(plantingFetchDescriptor) else {
            return
        }
        
        // In a real app, would use the WeatherService to determine watering needs
        // based on recent rainfall, temperature, etc.
        print("Checking watering needs for \(activePlantings.count) active plantings")
    }
    
    /// Update harvest predictions based on weather and growing conditions
    /// - Parameter modelContext: The model context
    private func updateHarvestPredictions(with modelContext: ModelContext) {
        // Need to use raw value comparison for enum in SwiftData predicates
        let activeStatus = PlantingStatus.active.rawValue
        
        let plantingFetchDescriptor = FetchDescriptor<Planting>(
            predicate: #Predicate<Planting> {
                $0.status.rawValue == activeStatus && $0.expectedHarvestDate != nil
            }
        )
        
        guard let plantingsWithHarvestDates = try? modelContext.fetch(plantingFetchDescriptor) else {
            return
        }
        
        // In a real app, would adjust harvest dates based on weather data
        // For now, just print a message
        print("Updating harvest predictions for \(plantingsWithHarvestDates.count) plantings")
    }
    
    /// Check for any weather alerts that might affect gardens
    /// - Parameter modelContext: The model context
    func checkWeatherAlerts(with modelContext: ModelContext) async {
        // This would use the WeatherService in a real app
        // For now, just print a message
        print("Checking for weather alerts that might affect gardens")
    }
}

/// Extension to handle scheduled background tasks
extension AppCoordinator {
    /// Set up background tasks for checking garden conditions
    func setupBackgroundTasks() {
        // In a real app, would register for background processing
        // and set up schedules for checking weather, sending notifications, etc.
        print("Setting up background tasks")
    }
    
    /// Handle a background refresh task
    /// - Parameter task: The background task
    func handleBackgroundRefresh(_ task: UIBackgroundTaskIdentifier) {
        // In a real app, would perform background refresh operations
        // such as checking weather, updating tasks, etc.
        print("Handling background refresh")
    }
}
