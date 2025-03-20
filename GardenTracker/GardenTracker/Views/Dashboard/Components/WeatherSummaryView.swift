//
//  WeatherSummaryView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData
import WeatherKit
import MapKit

struct WeatherSummaryView: View {
    let weatherData: WeatherData

    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's Weather")
                .headlineStyle()
            
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: weatherIconName)
                            .font(.system(size: 40))
                            .foregroundColor(AppColors.info)
                        
                        // Use the method from WeatherService.shared
                        Text(WeatherService.shared.getTemperatureInPreferredUnit(temperatureInFahrenheit: weatherData.temperature))
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    Text(weatherData.conditions)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    LabeledContent("Precipitation", value: WeatherService.shared.getLocalizedPrecipitation(precipitationInMm: weatherData.precipitation * 100))
                    LabeledContent("Humidity", value: "\(Int(weatherData.humidity))%")
                    LabeledContent("Wind", value: WeatherService.shared.getLocalizedWindSpeed(windSpeedInKmh: weatherData.windSpeed))
                }
                .font(.caption)
            }
            
            if weatherNeedsWarning {
                WarningBannerView(message: weatherWarningMessage)
                    .padding(.top, 8)
            }
        }
        .cardStyle()
    }
    
    private var weatherIconName: String {
        switch weatherData.conditions.lowercased() {
        case let condition where condition.contains("cloud"):
            return "cloud"
        case let condition where condition.contains("rain"):
            return "cloud.rain"
        case let condition where condition.contains("snow"):
            return "cloud.snow"
        case let condition where condition.contains("sun") || condition.contains("clear"):
            return "sun.max"
        default:
            return "cloud.sun"
        }
    }
    
    private var weatherNeedsWarning: Bool {
        // Simple logic to determine if weather conditions warrant a warning
        weatherData.temperature > 90 || weatherData.temperature < 32 || weatherData.precipitation > 0.5
    }
    
    private var weatherWarningMessage: String {
        if weatherData.temperature > 90 {
            return "Heat alert: Consider watering your plants in the evening"
        } else if weatherData.temperature < 32 {
            return "Frost alert: Protect sensitive plants"
        } else if weatherData.precipitation > 0.5 {
            return "Heavy rain expected: Check drainage in your garden"
        }
        return ""
    }
}

struct WeatherSummaryPlaceholder: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's Weather")
                .font(.headline)
            
            Text("Loading weather data...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

#Preview {
    WeatherSummaryView(
        weatherData: WeatherData(
            temperature: 85,
            conditions: "Partly Cloudy",
            precipitation: 0.3,
            humidity: 65,
            windSpeed: 8,
            date: Date()
        )
    )
}
