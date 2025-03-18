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
//                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: weatherIconName)
                            .font(.system(size: 40))
                            .foregroundColor(AppColors.info)
                        
                        Text("\(Int(weatherData.temperature))°F")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    Text(weatherData.conditions)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    LabeledContent("Precipitation", value: "\(Int(weatherData.precipitation * 100))%")
                    LabeledContent("Humidity", value: "\(Int(weatherData.humidity))%")
                    LabeledContent("Wind", value: "\(Int(weatherData.windSpeed)) mph")
                }
                .font(.caption)
            }
            
            if weatherNeedsWarning {
                WarningBannerView(message: weatherWarningMessage)
                    .padding(.top, 8)
            }
        }
//        .padding()
        .cardStyle()
//        .background(Color(.systemBackground))
//        .clipShape(RoundedRectangle(cornerRadius: 12))
//        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
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
