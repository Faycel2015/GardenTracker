//
//  SampleDataProvider.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftData
import SwiftUI

/// Provides sample data for the app
class SampleDataProvider {
    static let shared = SampleDataProvider()

    private init() {}

    /// Create sample data in the model context
    /// - Parameter modelContext: The model context to populate
    func createSampleData(in modelContext: ModelContext) {
        createSamplePlants(in: modelContext)
        createSampleGardens(in: modelContext)
    }

    /// Create sample plant data
    /// - Parameter modelContext: The model context to populate
    func createSamplePlants(in modelContext: ModelContext) {
        // Tomatoes
        let tomato = Plant(
            name: "Beefsteak Tomato",
            type: "Tomato",
            plantDescription: "Large, classic slicing tomato with meaty flesh and rich flavor. Indeterminate variety that produces throughout the season.",
            spacing: 24,
            daysToMaturity: 85,
            sunRequirement: .fullSun,
            waterRequirement: .moderate,
            plantingDepth: 0.25,
            companionPlants: ["Basil", "Marigold", "Nasturtium", "Onion", "Carrot"],
            adversaryPlants: ["Potato", "Corn", "Fennel", "Kohlrabi"],
            growingSeasons: [.spring, .summer],
            growthStages: [.seed, .seedling, .vegetative, .flowering, .fruiting, .harvest]
        )
        modelContext.insert(tomato)

        let cherryTomato = Plant(
            name: "Cherry Tomato",
            type: "Tomato",
            plantDescription: "Sweet, bite-sized tomatoes that grow in clusters. Prolific producer ideal for snacking and salads.",
            spacing: 18,
            daysToMaturity: 65,
            sunRequirement: .fullSun,
            waterRequirement: .moderate,
            plantingDepth: 0.25,
            companionPlants: ["Basil", "Marigold", "Nasturtium", "Onion", "Carrot"],
            adversaryPlants: ["Potato", "Corn", "Fennel", "Kohlrabi"],
            growingSeasons: [.spring, .summer],
            growthStages: [.seed, .seedling, .vegetative, .flowering, .fruiting, .harvest]
        )
        modelContext.insert(cherryTomato)

        // Lettuce
        let lettuce = Plant(
            name: "Butterhead Lettuce",
            type: "Lettuce",
            plantDescription: "Tender lettuce with soft, buttery leaves forming a loose head. Heat-sensitive but cold-tolerant.",
            spacing: 8,
            daysToMaturity: 60,
            sunRequirement: .partialSun,
            waterRequirement: .moderate,
            plantingDepth: 0.125,
            companionPlants: ["Carrot", "Radish", "Cucumber", "Onion"],
            adversaryPlants: [],
            growingSeasons: [.spring, .fall],
            growthStages: [.seed, .seedling, .vegetative, .mature, .harvest]
        )
        modelContext.insert(lettuce)

        // Carrots
        let carrot = Plant(
            name: "Nantes Carrot",
            type: "Carrot",
            plantDescription: "Sweet, cylindrical carrots with rounded tips. Uniform shape makes them perfect for home gardens.",
            spacing: 3,
            daysToMaturity: 70,
            sunRequirement: .fullSun,
            waterRequirement: .moderate,
            plantingDepth: 0.25,
            companionPlants: ["Tomato", "Onion", "Rosemary", "Sage", "Pea"],
            adversaryPlants: ["Dill"],
            growingSeasons: [.spring, .fall],
            growthStages: [.seed, .seedling, .vegetative, .mature, .harvest]
        )
        modelContext.insert(carrot)

        // Peppers
        let bellPepper = Plant(
            name: "Bell Pepper",
            type: "Pepper",
            plantDescription: "Sweet, bell-shaped peppers that mature from green to red, yellow, or orange. Versatile for cooking and eating fresh.",
            spacing: 18,
            daysToMaturity: 75,
            sunRequirement: .fullSun,
            waterRequirement: .moderate,
            plantingDepth: 0.25,
            companionPlants: ["Basil", "Onion", "Spinach", "Tomato"],
            adversaryPlants: ["Fennel", "Kohlrabi"],
            growingSeasons: [.spring, .summer],
            growthStages: [.seed, .seedling, .vegetative, .flowering, .fruiting, .harvest]
        )
        modelContext.insert(bellPepper)

        // Zucchini
        let zucchini = Plant(
            name: "Zucchini",
            type: "Summer Squash",
            plantDescription: "Productive summer squash with dark green skin and white flesh. Best harvested young for tender texture.",
            spacing: 36,
            daysToMaturity: 50,
            sunRequirement: .fullSun,
            waterRequirement: .moderate,
            plantingDepth: 1.0,
            companionPlants: ["Nasturtium", "Corn", "Bean"],
            adversaryPlants: ["Potato"],
            growingSeasons: [.spring, .summer],
            growthStages: [.seed, .seedling, .vegetative, .flowering, .fruiting, .harvest]
        )
        modelContext.insert(zucchini)

        // Basil
        let basil = Plant(
            name: "Genovese Basil",
            type: "Herb",
            plantDescription: "Aromatic culinary herb with bright green leaves, perfect for Italian cuisine and pesto.",
            spacing: 10,
            daysToMaturity: 30,
            sunRequirement: .fullSun,
            waterRequirement: .moderate,
            plantingDepth: 0.125,
            companionPlants: ["Tomato", "Pepper", "Oregano"],
            adversaryPlants: [],
            growingSeasons: [.spring, .summer],
            growthStages: [.seed, .seedling, .vegetative, .mature, .harvest]
        )
        modelContext.insert(basil)

        // Onions
        let onion = Plant(
            name: "Yellow Onion",
            type: "Onion",
            plantDescription: "Versatile onion with golden skin and white flesh. Strong flavor that mellows when cooked.",
            spacing: 6,
            daysToMaturity: 100,
            sunRequirement: .fullSun,
            waterRequirement: .moderate,
            plantingDepth: 1.0,
            companionPlants: ["Tomato", "Carrot", "Beet", "Lettuce"],
            adversaryPlants: ["Bean", "Pea"],
            growingSeasons: [.spring, .fall],
            growthStages: [.seed, .seedling, .vegetative, .mature, .harvest]
        )
        modelContext.insert(onion)

        // Beans
        let greenBean = Plant(
            name: "Bush Bean",
            type: "Bean",
            plantDescription: "Productive bush-type green beans that don't require staking. Tender pods are delicious fresh or cooked.",
            spacing: 6,
            daysToMaturity: 55,
            sunRequirement: .fullSun,
            waterRequirement: .moderate,
            plantingDepth: 1.0,
            companionPlants: ["Corn", "Cucumber", "Potato", "Strawberry"],
            adversaryPlants: ["Onion", "Garlic"],
            growingSeasons: [.spring, .summer],
            growthStages: [.seed, .seedling, .vegetative, .flowering, .fruiting, .harvest]
        )
        modelContext.insert(greenBean)

        // Kale
        let kale = Plant(
            name: "Lacinato Kale",
            type: "Kale",
            plantDescription: "Also known as dinosaur kale, with dark blue-green leaves and a sweeter flavor than other kales.",
            spacing: 12,
            daysToMaturity: 60,
            sunRequirement: .fullSun,
            waterRequirement: .moderate,
            plantingDepth: 0.5,
            companionPlants: ["Beet", "Celery", "Cucumber", "Onion"],
            adversaryPlants: ["Strawberry"],
            growingSeasons: [.spring, .fall, .winter],
            growthStages: [.seed, .seedling, .vegetative, .mature, .harvest]
        )
        modelContext.insert(kale)

        // Radish
        let radish = Plant(
            name: "Cherry Belle Radish",
            type: "Radish",
            plantDescription: "Quick-growing round radish with bright red skin and crisp white flesh. Mild flavor perfect for salads.",
            spacing: 2,
            daysToMaturity: 22,
            sunRequirement: .fullSun,
            waterRequirement: .moderate,
            plantingDepth: 0.5,
            companionPlants: ["Lettuce", "Spinach", "Cucumber", "Pea"],
            adversaryPlants: ["Hyssop"],
            growingSeasons: [.spring, .fall],
            growthStages: [.seed, .seedling, .vegetative, .mature, .harvest]
        )
        modelContext.insert(radish)

        // Cucumber
        let cucumber = Plant(
            name: "Slicing Cucumber",
            type: "Cucumber",
            plantDescription: "Crisp, dark green cucumbers perfect for fresh eating. Best trellised to save space and prevent disease.",
            spacing: 12,
            daysToMaturity: 65,
            sunRequirement: .fullSun,
            waterRequirement: .high,
            plantingDepth: 1.0,
            companionPlants: ["Bean", "Corn", "Pea", "Radish", "Sunflower"],
            adversaryPlants: ["Potato", "Aromatic Herbs"],
            growingSeasons: [.spring, .summer],
            growthStages: [.seed, .seedling, .vegetative, .flowering, .fruiting, .harvest]
        )
        modelContext.insert(cucumber)
    }

    /// Create sample garden data
    /// - Parameter modelContext: The model context to populate
    func createSampleGardens(in modelContext: ModelContext) {
        // Create a sample garden
        let homeGarden = Garden(
            name: "Home Garden",
            width: 20,
            length: 30,
            location: "Backyard",
            soilType: "Clay Loam",
            hardinessZone: "7b"
        )
        modelContext.insert(homeGarden)

        // Create garden beds for the garden
        let raisedBed1 = GardenBed(
            name: "Raised Bed 1",
            width: 4,
            length: 8,
            xPosition: 2,
            yPosition: 3,
            soilType: "Garden Mix"
        )
        raisedBed1.garden = homeGarden
        modelContext.insert(raisedBed1)

        let raisedBed2 = GardenBed(
            name: "Raised Bed 2",
            width: 4,
            length: 8,
            xPosition: 2,
            yPosition: 12,
            soilType: "Garden Mix with Compost"
        )
        raisedBed2.garden = homeGarden
        modelContext.insert(raisedBed2)

        let inGroundBed = GardenBed(
            name: "In-Ground Bed",
            width: 10,
            length: 4,
            xPosition: 8,
            yPosition: 3,
            soilType: "Amended Native Soil"
        )
        inGroundBed.garden = homeGarden
        modelContext.insert(inGroundBed)

        // Create crop rotation history for the beds
        let rotation1 = CropRotation(
            year: Calendar.current.component(.year, from: Date()) - 1,
            season: .summer,
            cropFamily: "Solanaceae"
        )
        rotation1.gardenBed = raisedBed1
        modelContext.insert(rotation1)

        let rotation2 = CropRotation(
            year: Calendar.current.component(.year, from: Date()),
            season: .spring,
            cropFamily: "Brassicaceae"
        )
        rotation2.gardenBed = raisedBed1
        modelContext.insert(rotation2)

        // Create a community garden
        let communityGarden = Garden(
            name: "Community Garden",
            width: 50,
            length: 75,
            location: "Downtown",
            soilType: "Loam",
            hardinessZone: "7b"
        )
        modelContext.insert(communityGarden)

        let plotA = GardenBed(
            name: "Plot A",
            width: 8,
            length: 12,
            xPosition: 5,
            yPosition: 10,
            soilType: "Loam with Compost"
        )
        plotA.garden = communityGarden
        modelContext.insert(plotA)

        // Add some sample plantings
        // First, fetch our sample plants
        let plantFetchDescriptor = FetchDescriptor<Plant>()
        guard let plants = try? modelContext.fetch(plantFetchDescriptor) else {
            return
        }

        let tomato = plants.first { $0.name == "Beefsteak Tomato" }
        let basil = plants.first { $0.name == "Genovese Basil" }
        let lettuce = plants.first { $0.name == "Butterhead Lettuce" }
        let carrot = plants.first { $0.name == "Nantes Carrot" }

        // Add a tomato planting
        if let tomato = tomato {
            let tomatoPlanting = Planting(
                datePlanted: Calendar.current.date(byAdding: .day, value: -30, to: Date())!,
                quantity: 4,
                status: .active,
                xPosition: 1.0,
                yPosition: 1.0,
                expectedHarvestDate: Calendar.current.date(byAdding: .day, value: 50, to: Date())
            )
            tomatoPlanting.plant = tomato
            tomatoPlanting.gardenBed = raisedBed1
            modelContext.insert(tomatoPlanting)

            // Add a growth log for the tomato
            let tomatoLog = GrowthLog(
                date: Calendar.current.date(byAdding: .day, value: -15, to: Date())!,
                notes: "Plants are establishing well. About 12 inches tall now.",
                stage: .vegetative
            )
            tomatoLog.plant = tomato
            tomatoLog.planting = tomatoPlanting
            modelContext.insert(tomatoLog)
        }

        // Add a basil planting
        if let basil = basil {
            let basilPlanting = Planting(
                datePlanted: Calendar.current.date(byAdding: .day, value: -25, to: Date())!,
                quantity: 6,
                status: .active,
                xPosition: 1.0,
                yPosition: 2.0,
                expectedHarvestDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())
            )
            basilPlanting.plant = basil
            basilPlanting.gardenBed = raisedBed1
            modelContext.insert(basilPlanting)
        }

        // Add lettuce to raised bed 2
        if let lettuce = lettuce {
            let lettucePlanting = Planting(
                datePlanted: Calendar.current.date(byAdding: .day, value: -40, to: Date())!,
                quantity: 12,
                status: .active,
                xPosition: 2.0,
                yPosition: 2.0,
                expectedHarvestDate: Calendar.current.date(byAdding: .day, value: 10, to: Date())
            )
            lettucePlanting.plant = lettuce
            lettucePlanting.gardenBed = raisedBed2
            modelContext.insert(lettucePlanting)

            // Add a harvest log for lettuce
            let lettuceHarvest = HarvestLog(
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                quantity: 2.0,
                unit: .count,
                quality: 5,
                notes: "Harvested two heads. Tender and delicious!"
            )
            lettuceHarvest.planting = lettucePlanting
            modelContext.insert(lettuceHarvest)
        }

        // Add carrots to in-ground bed
        if let carrot = carrot {
            let carrotPlanting = Planting(
                datePlanted: Calendar.current.date(byAdding: .day, value: -60, to: Date())!,
                quantity: 25,
                status: .active,
                xPosition: 5.0,
                yPosition: 2.0,
                expectedHarvestDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())
            )
            carrotPlanting.plant = carrot
            carrotPlanting.gardenBed = inGroundBed
            modelContext.insert(carrotPlanting)
        }

        // Add some sample tasks
        let wateringTask = Task(
            title: "Water tomatoes and basil",
            description: "Check soil moisture first. Water deeply at the base of plants.",
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            type: .watering,
            isRecurring: true,
            recurrencePattern: .daily
        )
        wateringTask.garden = homeGarden
        modelContext.insert(wateringTask)

        let harvestTask = Task(
            title: "Harvest lettuce",
            description: "Cut outer leaves or whole heads as needed. Best harvested in the morning.",
            dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            type: .harvesting
        )
        harvestTask.garden = homeGarden
        modelContext.insert(harvestTask)

        let weedingTask = Task(
            title: "Weed garden beds",
            description: "Focus on removing weeds around the base of tomato plants.",
            dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            type: .weeding,
            isRecurring: true,
            recurrencePattern: .weekly
        )
        weedingTask.garden = homeGarden
        modelContext.insert(weedingTask)

        let plantingTask = Task(
            title: "Plant second succession of lettuce",
            description: "Sow seeds in the empty space in Raised Bed 2",
            dueDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            type: .planting
        )
        plantingTask.garden = homeGarden
        modelContext.insert(plantingTask)
    }
}
