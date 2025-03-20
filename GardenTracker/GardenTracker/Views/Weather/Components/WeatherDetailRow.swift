//
//  WeatherDetailRow.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct WeatherDetailRow: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(AppColors.info)
            
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(AppColors.textPrimary)
            
            Text(label)
                .foregroundColor(AppColors.textSecondary)
        }
        .font(.caption)
    }
}

#Preview {
    Group {
        VStack(spacing: 16) {
            // Temperature preview
            WeatherDetailRow(
                icon: "thermometer",
                value: WeatherService.shared.getTemperatureInPreferredUnit(temperatureInFahrenheit: 75.0),
                label: "Temperature"
            )
            
            // Wind speed preview
            WeatherDetailRow(
                icon: "wind",
                value: WeatherService.shared.getLocalizedWindSpeed(windSpeedInKmh: 12.0),
                label: "Wind"
            )
            
            // Precipitation preview
            WeatherDetailRow(
                icon: "umbrella.fill",
                value: WeatherService.shared.getLocalizedPrecipitation(precipitationInMm: 8.5),
                label: "Precipitation"
            )
            
            // Humidity preview (standard percentage)
            WeatherDetailRow(
                icon: "drop.fill",
                value: "65%",
                label: "Humidity"
            )
        }
        .padding()
        .background(AppColors.cardBackground)
        .frame(maxWidth: 300)
    }
}
