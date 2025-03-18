//
//  DateFormatting.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import Foundation
import SwiftUI

/// Utility for formatting dates in a consistent way throughout the app
struct DateFormatting {
    // MARK: - Shared Formatter Instances
    
    /// Shared date formatter for short dates (MM/dd/yyyy)
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    /// Shared date formatter for medium dates (Jan 1, 2023)
    static let mediumDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    /// Shared date formatter for long dates (January 1, 2023)
    static let longDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    /// Shared date formatter for short time (3:30 PM)
    static let shortTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    /// Shared date formatter for medium date and time (Jan 1, 2023 at 3:30 PM)
    static let mediumDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    /// Shared date formatter for month and year (January 2023)
    static let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    /// Shared date formatter for month abbr and year (Jan 2023)
    static let shortMonthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()
    
    /// Shared date formatter for weekday (Monday)
    static let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    /// Shared date formatter for short weekday (Mon)
    static let shortWeekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    /// Shared date formatter for custom planting date format (Apr 15)
    static let plantingDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    /// Shared date formatter for growing season dates (Spring 2023)
    static let seasonYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    // MARK: - Relative Date Formatting
    
    /// Format a date relative to now (Today, Yesterday, etc.)
    /// - Parameter date: The date to format
    /// - Returns: Formatted string representing the date
    static func formatRelative(_ date: Date) -> String {
        if date.isToday {
            return "Today"
        } else if date.isYesterday {
            return "Yesterday"
        } else if date.isTomorrow {
            return "Tomorrow"
        } else if date.isCurrentWeek {
            return shortWeekdayFormatter.string(from: date)
        } else {
            return shortDateFormatter.string(from: date)
        }
    }
    
    /// Format a date relative to now with time
    /// - Parameter date: The date to format
    /// - Returns: Formatted string representing the date and time
    static func formatRelativeWithTime(_ date: Date) -> String {
        let timeString = shortTimeFormatter.string(from: date)
        
        if date.isToday {
            return "Today at \(timeString)"
        } else if date.isYesterday {
            return "Yesterday at \(timeString)"
        } else if date.isTomorrow {
            return "Tomorrow at \(timeString)"
        } else if date.isCurrentWeek {
            let weekday = shortWeekdayFormatter.string(from: date)
            return "\(weekday) at \(timeString)"
        } else {
            return mediumDateTimeFormatter.string(from: date)
        }
    }
    
    // MARK: - Task Due Date Formatting
    
    /// Format a task due date with appropriate styling
    /// - Parameter dueDate: The task due date
    /// - Returns: Formatted string representing the due date
    static func formatTaskDueDate(_ dueDate: Date) -> String {
        if dueDate.isToday {
            return "Today"
        } else if dueDate.isTomorrow {
            return "Tomorrow"
        } else if dueDate < Date() {
            return "Overdue: \(shortDateFormatter.string(from: dueDate))"
        } else if dueDate.isCurrentWeek {
            return weekdayFormatter.string(from: dueDate)
        } else {
            return mediumDateFormatter.string(from: dueDate)
        }
    }
    
    // MARK: - Harvest Date Formatting
    
    /// Format a harvest date range
    /// - Parameters:
    ///   - plantingDate: The date the plant was planted
    ///   - daysToMaturity: The expected days to maturity
    /// - Returns: Formatted string representing the harvest date range
    static func formatHarvestDateRange(plantingDate: Date, daysToMaturity: Int) -> String {
        // Calculate earliest and latest harvest dates (with some variability)
        let earliestHarvest = plantingDate.addingDays(daysToMaturity - 7)
        let expectedHarvest = plantingDate.addingDays(daysToMaturity)
        let latestHarvest = plantingDate.addingDays(daysToMaturity + 7)
        
        // Format dates
        let earliestString = plantingDateFormatter.string(from: earliestHarvest)
//        let expectedString = plantingDateFormatter.string(from: expectedHarvest)
        let latestString = plantingDateFormatter.string(from: latestHarvest)
        
        // If all dates are in the same month
        if earliestHarvest.month == latestHarvest.month {
            return "\(earliestHarvest.shortMonthName) \(earliestHarvest.day)-\(latestHarvest.day)"
        }
        
        // If earliest and expected are in the same month
        if earliestHarvest.month == expectedHarvest.month {
            return "\(earliestString)-\(latestString)"
        }
        
        // Different months
        return "\(earliestString) to \(latestString)"
    }
    
    // MARK: - Growing Season Formatting
    
    /// Format a growing season with year
    /// - Parameters:
    ///   - season: The growing season
    ///   - year: The year
    /// - Returns: Formatted string representing the growing season and year
    static func formatSeasonYear(season: GrowingSeason, year: Int) -> String {
        return "\(season.rawValue) \(year)"
    }
    
    /// Format a date range for a growing season
    /// - Parameters:
    ///   - season: The growing season
    ///   - year: The year
    /// - Returns: Formatted string representing the date range for the season
    static func formatSeasonDateRange(season: GrowingSeason, year: Int) -> String {
        var startDate: Date
        var endDate: Date
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        
        switch season {
        case .spring:
            components.month = 3
            components.day = 20
            startDate = calendar.date(from: components)!
            
            components.month = 6
            components.day = 20
            endDate = calendar.date(from: components)!
        case .summer:
            components.month = 6
            components.day = 21
            startDate = calendar.date(from: components)!
            
            components.month = 9
            components.day = 21
            endDate = calendar.date(from: components)!
        case .fall:
            components.month = 9
            components.day = 22
            startDate = calendar.date(from: components)!
            
            components.month = 12
            components.day = 20
            endDate = calendar.date(from: components)!
        case .winter:
            components.month = 12
            components.day = 21
            startDate = calendar.date(from: components)!
            
            components.year = year + 1
            components.month = 3
            components.day = 19
            endDate = calendar.date(from: components)!
        case .yearRound:
            components.month = 1
            components.day = 1
            startDate = calendar.date(from: components)!
            
            components.month = 12
            components.day = 31
            endDate = calendar.date(from: components)!
        }
        
        return "\(plantingDateFormatter.string(from: startDate)) - \(plantingDateFormatter.string(from: endDate))"
    }
    
    // MARK: - Countdown Formatting
    
    /// Format a countdown to a date
    /// - Parameter date: The target date
    /// - Returns: Formatted string representing the countdown
    static func formatCountdown(to date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: Date(), to: date)
        
        if let day = components.day, let hour = components.hour {
            if day > 0 {
                return "\(day) day\(day == 1 ? "" : "s")"
            } else if hour > 0 {
                return "\(hour) hour\(hour == 1 ? "" : "s")"
            } else if let minute = components.minute, minute > 0 {
                return "\(minute) minute\(minute == 1 ? "" : "s")"
            } else {
                return "Now"
            }
        }
        
        return ""
    }
}

// MARK: - String Extension for Date Parsing

extension String {
    /// Parse a string into a date using a specified format
    /// - Parameter format: The date format string
    /// - Returns: Optional Date if parsing was successful
    func toDate(withFormat format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
