//
//  GardenTrackerApp.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

@main
struct GardenTrackerApp: App {
    @StateObject private var coordinator = AppCoordinator.shared

    // Properly initialize the ModelContainer with all schema entities
    var sharedModelContainer: ModelContainer = {
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
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator) // Inject coordinator globally
                .modelContainer(sharedModelContainer) // Attach model container
                .onAppear {
                    let context = sharedModelContainer.mainContext
                    coordinator.initializeApp(with: context)
                }
        }
    }
}
