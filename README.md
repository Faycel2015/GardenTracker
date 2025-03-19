# 🌿 GardenTracker - Vegetable Gardening App

GardenTracker is a comprehensive iOS application designed to help users plan, manage, and maintain their vegetable gardens throughout the growing season. Built with SwiftUI and SwiftData, it provides a robust set of tools for garden enthusiasts of all experience levels.

## Features

### Garden Planning
- **Garden Bed Designer**: Create and customize garden layouts with precise dimensions
- **Plant Spacing Calculator**: Optimize plant placement for maximum yield
- **Companion Planting Guide**: Get recommendations for plant combinations that thrive together
- **Crop Rotation Planning**: Maintain soil health with smart rotation suggestions

### Plant Database
- **Comprehensive Plant Library**: Detailed information on common vegetable crops
- **Growing Requirements**: Learn optimal conditions for each plant
- **Seasonal Planting Calendar**: Know exactly when to plant based on your hardiness zone
- **Growth Stage Tracking**: Visual references for each stage of plant development

### Task Management
- **Personalized Task Schedule**: Never miss important gardening activities
- **Automated Reminders**: Get notifications for watering, fertilizing, and harvesting
- **Task Completion Tracking**: Keep a record of your gardening activities
- **Recurring Task Support**: Set up regular maintenance schedules

### Growth Tracking
- **Photo Journal**: Document plant progress with integrated photo capabilities
- **Harvest Logging**: Record yields and quality ratings
- **Problem Identification**: Document and solve plant health issues
- **Notes System**: Keep detailed observations organized

### Weather Integration
- **Local Weather Forecast**: Access current conditions and forecasts
- **Frost & Heat Alerts**: Receive warnings to protect your plants
- **Watering Recommendations**: Optimize watering based on recent and upcoming precipitation

## Technical Architecture

GardenTracker is built using Swift's latest frameworks and follows modern iOS design patterns:

- **SwiftUI**: The entire UI is built with SwiftUI for a modern, responsive interface
- **SwiftData**: Persistent storage using Apple's latest data framework, making data management seamless
- **MVVM Architecture**: Clear separation of data and presentation logic
- **Service Layer Pattern**: Dedicated services for weather, plant spacing, and other specialized tasks
- **Coordinator Pattern**: Centralized navigation and app state management

## 🚧 Project Structure

The project is organized into several key directories to keep the codebase maintainable and modular. Below is the folder structure:

```plaintext
GardenTracker/
├── App/
├── Models/
├── Resources/
├── Services/
├── Utilities/
├── Views/
├── Info
└── Item

### Folder Descriptions:

- **App/**: Contains the main app entry point and app coordinator for navigation management.
- **Models/**: Includes the data models for gardens, plants, tasks, and other app-specific entities.
- **Views/**: Holds the SwiftUI views for the app, separated by different features like gardens, plants, tasks, and weather.
- **Services/**: Contains service classes for functionalities like plant spacing, companion planting, and weather service integration.
- **Utilities/**: Includes helper files for color and date utilities, as well as extensions for various common tasks.
- **Resources/**: Contains the app's assets such as images, colors, and launch screen storyboard.

## Models

The app uses the following core models:

- **Garden**: Represents a garden with various properties and contains garden beds
- **GardenBed**: Represents a specific growing area within a garden
- **Plant**: Contains all information about a plant variety
- **Planting**: Represents an instance of a plant in a specific location
- **Task**: Gardening tasks with due dates and recurrence patterns
- **GrowthLog**: Records plant growth stages with optional photos
- **HarvestLog**: Tracks harvest quantity and quality
- **CropRotation**: Maintains history of crop families for rotation planning

## Services

Specialized services provide key functionality:

- **PlantSpacingService**: Calculates optimal plant spacing and layouts
- **CompanionPlantingService**: Provides plant compatibility recommendations
- **CropRotationService**: Suggests rotation sequences based on plant families
- **PlantingCalendarService**: Determines optimal planting times by hardiness zone
- **WeatherService**: Interfaces with WeatherKit for forecasts and alerts
- **AppCoordinator**: Manages app-wide state and initialization

## Getting Started

### Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

### Installation
1. Clone the repository
   ```bash
   git clone https://github.com/Faycel2015/GardenTracker.git

	2	Open GardenTracker.xcodeproj in Xcode
	3	Build and run on your device or simulator
Future Enhancements
Planned features for future releases:
	•	Garden layout sharing and export capabilities
	•	Plant disease identification using Vision framework
	•	Integration with smart garden sensors
	•	Expanded plant database with search and filtering
	•	Community features for sharing gardening tips and harvests
	•	Multiple garden location support with different climate zones
	•	Extended statistical reporting on garden performance
Contributors
Built with passion by garden enthusiasts who code!
License
This project is licensed under the MIT License - see the LICENSE file for details.
