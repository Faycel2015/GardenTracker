//
//  ColorUtilities.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI

/// A collection of app colors used throughout the GardenTracker app
struct AppColors {
    // Brand colors
    static let primary = Color("primaryGreen")
    static let secondary = Color("accentOrange")
    
    // UI Colors
    static let background = Color("backgroundColor")
    static let cardBackground = Color("cardBackground")
    static let textPrimary = Color("textPrimary")
    static let textSecondary = Color("textSecondary")
    
    // Semantic colors
    static let success = Color("successGreen")
    static let warning = Color("warningYellow")
    static let error = Color("errorRed")
    static let info = Color("infoBlue")
    
    // Garden element colors
    static let soil = Color("soilBrown")
    static let foliage = Color("foliageGreen")
    static let wood = Color("woodBrown")
    static let water = Color("waterBlue")
    
    // Status colors
    static let statusPlanned = Color("grayPlanned")
    static let statusActive = Color("greenActive")
    static let statusHarvested = Color("orangeHarvested")
    static let statusFailed = Color("redFailed")
    static let statusRemoved = Color("purpleRemoved")
    
    // Task type colors
    static let taskPlanting = Color.green
    static let taskWatering = Color.blue
    static let taskFertilizing = Color.brown
    static let taskPruning = Color.purple
    static let taskWeeding = Color.yellow
    static let taskHarvesting = Color.orange
    static let taskPestControl = Color.red
    static let taskMaintenance = Color.gray
    static let taskOther = Color.gray
    
    /// Get a color for a task type
    /// - Parameter taskType: The task type
    /// - Returns: The associated color
    static func forTaskType(_ taskType: TaskType) -> Color {
        switch taskType {
        case .planting:
            return taskPlanting
        case .watering:
            return taskWatering
        case .fertilizing:
            return taskFertilizing
        case .pruning:
            return taskPruning
        case .weeding:
            return taskWeeding
        case .harvesting:
            return taskHarvesting
        case .pestControl:
            return taskPestControl
        case .maintenance:
            return taskMaintenance
        case .other:
            return taskOther
        }
    }
    
    /// Get a color for a planting status
    /// - Parameter status: The planting status
    /// - Returns: The associated color
    static func forPlantingStatus(_ status: PlantingStatus) -> Color {
        switch status {
        case .planned:
            return statusPlanned
        case .active:
            return statusActive
        case .harvested:
            return statusHarvested
        case .failed:
            return statusFailed
        case .removed:
            return statusRemoved
        }
    }
}

/// Utility for using dynamic color schemes for dark/light mode compatibility
struct DynamicColor {
    /// Create a color that adapts to light and dark mode
    /// - Parameters:
    ///   - light: Color for light mode
    ///   - dark: Color for dark mode
    /// - Returns: A dynamic color that changes based on color scheme
    static func adaptive(light: Color, dark: Color) -> Color {
        return Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

/// Theme manager for the app
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    private init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    /// Toggle between light and dark mode
    func toggleDarkMode() {
        isDarkMode.toggle()
    }
}
