//
//  WeatherService.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData
import WeatherKit
import CoreLocation
import MapKit

/// Service that interfaces with WeatherKit to provide weather data for gardening
class WeatherService {
    static let shared = WeatherService()
    
    private init() {}
    
    /// Fetch current weather data for a location
    /// - Parameter location: The location coordinates
    /// - Returns: Weather data for the location
    func fetchCurrentWeather(for location: CLLocation) async throws -> WeatherData {
        #if targetEnvironment(simulator) || true
        // Provide mock data for simulator or when WeatherKit can't be accessed
        return getMockCurrentWeather()
        #else
        // In a real app, this would use the WeatherKit API
        let weatherService = WeatherService.shared
        let weather = try await Task.detached(priority: .userInitiated) {
            return try await weatherService.weather(for: location)
        }.value
        
        let currentWeather = weather.currentWeather
        
        return WeatherData(
            temperature: currentWeather.temperature.value,
            conditions: currentWeather.condition.description,
            precipitation: currentWeather.precipitationIntensity.value,
            humidity: currentWeather.humidity * 100,
            windSpeed: currentWeather.wind.speed.value,
            date: currentWeather.date
        )
        #endif
    }
    
    /// Fetch weather forecast for a location
    /// - Parameter location: The location coordinates
    /// - Returns: Array of forecast data for the next several days
    func fetchForecast(for location: CLLocation) async throws -> [WeatherData] {
        #if targetEnvironment(simulator) || true
        // Provide mock data for simulator or when WeatherKit can't be accessed
        return getMockForecast()
        #else
        // In a real app, this would use the WeatherKit API
        let weatherService = WeatherService.shared
        let weather = try await Task.detached(priority: .userInitiated) {
            return try await weatherService.weather(for: location)
        }.value
        
        let forecast = weather.dailyForecast
        
        return forecast.forecast.map { day in
            return WeatherData(
                temperature: day.highTemperature.value,
                conditions: day.condition.description,
                precipitation: day.precipitationChance,
                humidity: day.humidity * 100,
                windSpeed: day.wind.speed.value,
                date: day.date
            )
        }
        #endif
    }
    
    /// Check for weather alerts and warnings
    /// - Parameter location: The location coordinates
    /// - Returns: Array of weather alerts if any
    func fetchWeatherAlerts(for location: CLLocation) async throws -> [String] {
        #if targetEnvironment(simulator) || true
        // Mock alerts for testing
        let mockAlerts = [
            "Heat Advisory: High temperatures expected to reach 95°F",
            "Frost Warning: Overnight temperatures may drop below freezing"
        ]
        
        // Randomly return alerts or empty array
        return Bool.random() ? [mockAlerts.randomElement()!] : []
        #else
        // In a real app, this would use the WeatherKit API for severe weather alerts
        let weatherService = WeatherService.shared
        let weather = try await Task.detached(priority: .userInitiated) {
            return try await weatherService.weather(for: location)
        }.value
        
        if let weatherAlerts = weather.weatherAlerts {
            return weatherAlerts.map { alert in
                return "\(alert.summary): \(alert.detailsURL?.absoluteString ?? "")"
            }
        } else {
            return []
        }
        #endif
    }
    
    /// Get watering recommendations based on weather
    /// - Parameters:
    ///   - location: The location coordinates
    ///   - plantTypes: Types of plants in the garden
    /// - Returns: Watering recommendation
    func getWateringRecommendation(for location: CLLocation, plantTypes: [String]) async throws -> WateringRecommendation {
        let currentWeather = try await fetchCurrentWeather(for: location)
        let forecast = try await fetchForecast(for: location)
        
        // Check if it has rained recently
        let hasRainedRecently = currentWeather.conditions.lowercased().contains("rain") ||
                               forecast.prefix(1).contains(where: { $0.conditions.lowercased().contains("rain") })
        
        // Check if rain is expected soon
        let rainExpectedSoon = forecast.prefix(2).contains(where: {
            $0.conditions.lowercased().contains("rain") && $0.precipitation > 0.3
        })
        
        // Check if it's very hot
        let isHot = currentWeather.temperature > 85
        
        // Check if it's very dry
        let isDry = currentWeather.humidity < 40
        
        // Calculate base watering need
        var wateringNeed: WateringNeed = .moderate
        
        if hasRainedRecently {
            wateringNeed = .low
        } else if isHot && isDry {
            wateringNeed = .high
        } else if rainExpectedSoon {
            wateringNeed = .low
        }
        
        // Adjust for plant types
        let hasThirstyPlants = plantTypes.contains(where: {
            $0.lowercased().contains("tomato") ||
            $0.lowercased().contains("cucumber") ||
            $0.lowercased().contains("squash")
        })
        
        if hasThirstyPlants && wateringNeed != .high {
            // Bump up watering need for thirsty plants
            wateringNeed = WateringNeed(rawValue: min(wateringNeed.rawValue + 1, WateringNeed.high.rawValue)) ?? wateringNeed
        }
        
        // Generate recommendation
        let recommendationText: String
        let bestTimeToWater: TimeOfDay
        
        switch wateringNeed {
        case .low:
            if hasRainedRecently {
                recommendationText = "Skip watering today. Recent rainfall should provide adequate moisture."
            } else if rainExpectedSoon {
                recommendationText = "Hold off on watering as rain is expected in the next 48 hours."
            } else {
                recommendationText = "Light watering recommended for seedlings and container plants only."
            }
            bestTimeToWater = .morning
            
        case .moderate:
            recommendationText = "Normal watering recommended. Water deeply at the base of plants."
            bestTimeToWater = isHot ? .evening : .morning
            
        case .high:
            if isHot && isDry {
                recommendationText = "Plants need extra water due to hot, dry conditions. Water deeply and consider mulching to retain moisture."
            } else {
                recommendationText = "Thorough watering needed. Make sure water penetrates 6-8 inches into soil."
            }
            bestTimeToWater = isHot ? .evening : .morning
        }
        
        return WateringRecommendation(
            need: wateringNeed,
            recommendation: recommendationText,
            bestTimeToWater: bestTimeToWater
        )
    }
    
    // MARK: - Mock Data
    
    /// Generate mock current weather data for testing
    /// - Returns: Mock weather data
    private func getMockCurrentWeather() -> WeatherData {
        return WeatherData(
            temperature: Double.random(in: 65...85),
            conditions: ["Sunny", "Partly Cloudy", "Cloudy", "Light Rain"].randomElement()!,
            precipitation: Double.random(in: 0...0.5),
            humidity: Double.random(in: 40...80),
            windSpeed: Double.random(in: 2...15),
            date: Date()
        )
    }
    
    /// Generate mock forecast data for testing
    /// - Returns: Array of mock forecast data
    private func getMockForecast() -> [WeatherData] {
        let calendar = Calendar.current
        let today = Date()
        
        return (1...7).map { day in
            let date = calendar.date(byAdding: .day, value: day, to: today)!
            
            return WeatherData(
                temperature: Double.random(in: 65...85),
                conditions: ["Sunny", "Partly Cloudy", "Cloudy", "Light Rain", "Thunderstorms"].randomElement()!,
                precipitation: Double.random(in: 0...0.7),
                humidity: Double.random(in: 40...80),
                windSpeed: Double.random(in: 2...15),
                date: date
            )
        }
    }
}

/// Watering needs based on weather conditions
enum WateringNeed: Int {
    case low = 0
    case moderate = 1
    case high = 2
}

/// Recommended time of day for watering
enum TimeOfDay {
    case morning
    case evening
}

/// Watering recommendation for garden plants
struct WateringRecommendation {
    let need: WateringNeed
    let recommendation: String
    let bestTimeToWater: TimeOfDay
}
