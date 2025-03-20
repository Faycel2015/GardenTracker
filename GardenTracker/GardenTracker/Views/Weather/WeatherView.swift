//
//  WeatherView.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import MapKit
import SwiftData
import SwiftUI
import WeatherKit

struct WeatherView: View {
    @State private var weatherData: [WeatherData] = []
    @State private var weatherForecast: [WeatherData] = []
    @State private var isLoading = true
    @State private var selectedLocation: String = "Current Location"
    @State private var hardinessZone: String = ""

    let weatherService = WeatherService.shared

    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView("Loading weather data...")
                        .padding()
                } else {
                    ScrollView {
                        weatherContent
                    }
                }
            }
            .navigationTitle("Weather")
            .task {
                loadWeatherData()
            }
            .refreshable {
                loadWeatherData()
            }
        }
    }

    // Breaking up the large view into smaller components
    private var weatherContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Current weather
            currentWeatherSection

            // Forecast
            forecastSection

            // Garden task recommendations
            recommendationsSection
        }
        .padding()
    }

    private var currentWeatherSection: some View {
        Group {
            if let currentWeather = weatherData.first {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Current Weather")
                            .font(.headline)

                        Spacer()

                        locationMenu
                    }

                    if !hardinessZone.isEmpty {
                        Text("Hardiness Zone: \(hardinessZone)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    currentWeatherDetails(currentWeather)

                    // Garden alerts based on weather
                    if let alert = weatherAlert(for: currentWeather) {
                        WarningBannerView(message: alert)
                            .padding(.top, 8)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
            } else {
                EmptyView()
            }
        }
    }

    private var locationMenu: some View {
        Menu {
            Button("Current Location") {
                selectedLocation = "Current Location"
                loadWeatherData()
            }

            Button("Update Location") {
                // Would show location search in real app
            }
        } label: {
            HStack {
                Text(selectedLocation)
                    .font(.caption)

                Image(systemName: "chevron.down")
                    .font(.caption)
            }
        }
    }

    private func currentWeatherDetails(_ currentWeather: WeatherData) -> some View {
        HStack(alignment: .top, spacing: 20) {
            VStack {
                Image(systemName: weatherIconName(for: currentWeather))
                    .font(.system(size: 56))
                    .symbolRenderingMode(.multicolor)
                    .padding(.bottom, 4)

                Text(currentWeather.conditions)
                    .font(.subheadline)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text(WeatherService.shared.getTemperatureInPreferredUnit(temperatureInFahrenheit: currentWeather.temperature))
                    .font(.system(size: 42, weight: .medium))

                WeatherDetailRow(icon: "drop.fill", value: "\(Int(currentWeather.humidity))%", label: "Humidity")

                // Use the localized wind speed function
                WeatherDetailRow(
                    icon: "wind",
                    value: WeatherService.shared.getLocalizedWindSpeed(windSpeedInKmh: currentWeather.windSpeed),
                    label: "Wind"
                )

                // Use the localized precipitation function for a better display
                WeatherDetailRow(
                    icon: "umbrella.fill",
                    value: WeatherService.shared.getLocalizedPrecipitation(precipitationInMm: currentWeather.precipitation * 100),
                    label: "Precipitation"
                )
            }
        }
    }

    private var forecastSection: some View {
        VStack(alignment: .leading) {
            Text("7-Day Forecast")
                .font(.headline)
                .padding(.bottom, 8)

            forecastList
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }

    private var forecastList: some View {
        VStack(spacing: 0) {
            ForEach(Array(zip(weatherForecast.indices, weatherForecast)), id: \.0) { index, forecast in
                forecastRow(forecast: forecast)

                if index < weatherForecast.count - 1 {
                    Divider()
                }
            }
        }
    }

    private func forecastRow(forecast: WeatherData) -> some View {
        HStack {
            Text(dayFormatter.string(from: forecast.date))
                .frame(width: 100, alignment: .leading)

            Image(systemName: weatherIconName(for: forecast))
                .symbolRenderingMode(.multicolor)
                .frame(width: 30)

            Text(forecast.conditions)
                .frame(width: 120, alignment: .leading)

            Spacer()

            // Fixed: Use forecast.temperature instead of weatherData.temperature
            Text(WeatherService.shared.getTemperatureInPreferredUnit(temperatureInFahrenheit: forecast.temperature))
                .fontWeight(.medium)
        }
        .padding(.vertical, 12)
    }

    private var recommendationsSection: some View {
        VStack(alignment: .leading) {
            Text("Weather-Based Recommendations")
                .font(.headline)
                .padding(.bottom, 8)

            ForEach(weatherRecommendations(), id: \.self) { recommendation in
                recommendationRow(recommendation)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }

    private func recommendationRow(_ recommendation: String) -> some View {
        HStack(alignment: .top) {
            Image(systemName: "leaf.fill")
                .foregroundColor(.green)
                .frame(width: 24, height: 24)

            Text(recommendation)
                .font(.subheadline)
        }
        .padding(.vertical, 4)
    }

    private func loadWeatherData() {
        isLoading = true

        // In a real app, use WeatherKit API
        // For now, simulate weather data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let today = Date()
            let calendar = Calendar.current

            weatherData = [
                WeatherData(
                    temperature: 22.5, // 22.5°C ≈ 72.5°F - reasonable temperature for most plants
                    conditions: "Partly Cloudy",
                    precipitation: 0.1,
                    humidity: 65.0,
                    windSpeed: 5.0,
                    date: today
                ),
            ]

            // Create 7-day forecast
            weatherForecast = (0 ..< 7).map { day in
                let date = calendar.date(byAdding: .day, value: day + 1, to: today)!
                return WeatherData(
                    temperature: Double.random(in: 15 ... 30), // Using Celsius for base data
                    conditions: ["Sunny", "Partly Cloudy", "Cloudy", "Light Rain", "Thunderstorms"].randomElement()!,
                    precipitation: Double.random(in: 0 ... 0.7),
                    humidity: Double.random(in: 50 ... 90),
                    windSpeed: Double.random(in: 2 ... 15),
                    date: date
                )
            }

            hardinessZone = "7b"
            isLoading = false
        }
    }

    private func weatherIconName(for weather: WeatherData) -> String {
        switch weather.conditions.lowercased() {
        case let c where c.contains("thunderstorm"):
            return "cloud.bolt.rain.fill"
        case let c where c.contains("rain"):
            return "cloud.rain.fill"
        case let c where c.contains("snow"):
            return "cloud.snow.fill"
        case let c where c.contains("cloud"):
            return "cloud.fill"
        case let c where c.contains("partly"):
            return "cloud.sun.fill"
        case let c where c.contains("sunny") || c.contains("clear"):
            return "sun.max.fill"
        default:
            return "cloud.sun.fill"
        }
    }

    private func weatherAlert(for weather: WeatherData) -> String? {
        // Convert thresholds to work with either unit system
        let isMetric = Locale.current.measurementSystem == .metric
        let highTempThreshold: Double = isMetric ? 32.0 : 90.0 // 32°C ≈ 90°F
        let lowTempThreshold: Double = isMetric ? 0.0 : 32.0 // 0°C = 32°F

        // Use appropriate precipitation units based on locale
        let heavyRainThreshold: Double = isMetric ? 12.0 : 0.5 // 12mm ≈ 0.5in

        // Use appropriate wind speed units based on locale
        let highWindThreshold: Double = isMetric ? 32.0 : 20.0 // 32km/h ≈ 20mph

        if weather.temperature > highTempThreshold {
            return "Heat alert: Consider watering your plants in the evening"
        } else if weather.temperature < lowTempThreshold {
            return "Frost alert: Protect sensitive plants from freezing"
        } else if weather.precipitation > heavyRainThreshold {
            return "Heavy rain expected: Check drainage in your garden"
        } else if weather.windSpeed > highWindThreshold {
            return "Strong winds expected: Secure tall plants and structures"
        }
        return nil
    }

    private func weatherRecommendations() -> [String] {
        var recommendations = [String]()

        if let currentWeather = weatherData.first {
            // Convert thresholds to work with either unit system
            let isMetric = Locale.current.measurementSystem == .metric
            let highTempThreshold: Double = isMetric ? 29.0 : 85.0 // 29°C ≈ 85°F
            let lowTempThreshold: Double = isMetric ? 4.0 : 40.0 // 4°C ≈ 40°F

            // Use appropriate precipitation units based on locale
            let significantRainThreshold: Double = isMetric ? 10.0 : 0.4 // 10mm ≈ 0.4in

            // Humidity is always a percentage, so no unit conversion needed
            let highHumidityThreshold: Double = 80.0

            if currentWeather.temperature > highTempThreshold {
                recommendations.append("Water deeply in the early morning or evening to avoid evaporation")
                recommendations.append("Apply mulch to retain soil moisture in hot weather")
            }

            if currentWeather.precipitation > significantRainThreshold {
                recommendations.append("Hold off on watering for 1-2 days after significant rainfall")
                recommendations.append("Check for standing water and improve drainage if needed")
            }

            if currentWeather.humidity > highHumidityThreshold {
                recommendations.append("Watch for fungal diseases in high humidity - ensure good air circulation")
            }

            if currentWeather.temperature < lowTempThreshold {
                recommendations.append("Protect tender plants from cold temperatures with row covers")
            }
        }

        // Add some general recommendations if list is empty
        if recommendations.isEmpty {
            recommendations.append("Ideal conditions for general garden maintenance")
            recommendations.append("Good day for planting and transplanting")
        }

        return recommendations
    }

    private var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
}

#Preview {
    WeatherView()
}
