//
//  ContentView.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "house")
                    }
                    .tag(0)
                
                GardensView()
                    .tabItem {
                        Label("Gardens", systemImage: "leaf")
                    }
                    .tag(1)
                
                PlantsView()
                    .tabItem {
                        Label("Plants", systemImage: "leaf.circle")
                    }
                    .tag(2)
                
                PlantingCalendarView()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tag(3)
                
                TasksView()
                    .tabItem {
                        Label("Tasks", systemImage: "checklist")
                    }
                    .tag(4)
                
                WeatherView()
                    .tabItem {
                        Label("Weather", systemImage: "cloud.sun")
                    }
                    .tag(5)
            }
            .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
            
            // Add a simple theme toggle button in the corner
            Button(action: {
                themeManager.toggleDarkMode()
            }) {
                Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                    .font(.system(size: 18))
                    .foregroundColor(themeManager.isDarkMode ? .yellow : AppColors.primary)
                    .padding(8)
                    .background(Color(.systemBackground).opacity(0.8))
                    .clipShape(Circle())
            }
            .padding(.trailing, 10)
            .padding(.top, 80) // Adjust as needed to avoid status bar
            .zIndex(1) // Ensure it's above other content
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppCoordinator.shared) // Inject coordinator
        .modelContainer(for: [
            Garden.self,
            Plant.self,
            GardenBed.self,
            Planting.self,
            Task.self,
            GrowthLog.self,
            HarvestLog.self,
            PlantNote.self,
            CropRotation.self,
        ], inMemory: true) // Ensure all models are available in preview
}
