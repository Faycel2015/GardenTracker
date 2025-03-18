//
//  DateExtensions.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import Foundation
import SwiftUI

extension Date {
    // MARK: - Date Comparison
    
    /// Check if a date is today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Check if a date is yesterday
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// Check if a date is tomorrow
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// Check if a date is in the past
    var isPast: Bool {
        return self < Date()
    }
    
    /// Check if a date is in the future
    var isFuture: Bool {
        return self > Date()
    }
    
    /// Check if a date is in the current week
    var isCurrentWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    /// Check if a date is in the current month
    var isCurrentMonth: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    /// Check if a date is in the current year
    var isCurrentYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    // MARK: - Date Components
    
    /// Get the day of the month
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    /// Get the month number (1-12)
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    /// Get the month name
    var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    /// Get the short month name
    var shortMonthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: self)
    }
    
    /// Get the year
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    /// Get the day of the week (1-7, where 1 is Sunday)
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    /// Get the day name of the week
    var weekdayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    
    /// Get the short day name of the week
    var shortWeekdayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
    
    /// Get the week of the year
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    /// Get the quarter of the year (1-4)
    var quarter: Int {
        let month = self.month
        return (month - 1) / 3 + 1
    }
    
    // MARK: - Date Creation
    
    /// Create a date at the start of the day
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// Create a date at the end of the day
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: self.startOfDay)!
    }
    
    /// Create a date at the start of the week
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }
    
    /// Create a date at the end of the week
    var endOfWeek: Date {
        var components = DateComponents()
        components.weekOfYear = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: self.startOfWeek)!
    }
    
    /// Create a date at the start of the month
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
    
    /// Create a date at the end of the month
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: self.startOfMonth)!
    }
    
    // MARK: - Date Modification
    
    /// Add days to a date
    /// - Parameter days: Number of days to add
    /// - Returns: New date with days added
    func addingDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    /// Add weeks to a date
    /// - Parameter weeks: Number of weeks to add
    /// - Returns: New date with weeks added
    func addingWeeks(_ weeks: Int) -> Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self)!
    }
    
    /// Add months to a date
    /// - Parameter months: Number of months to add
    /// - Returns: New date with months added
    func addingMonths(_ months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
    
    /// Add years to a date
    /// - Parameter years: Number of years to add
    /// - Returns: New date with years added
    func addingYears(_ years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self)!
    }
    
    // MARK: - Date Calculation
    
    /// Calculate days between two dates
    /// - Parameter date: The date to calculate difference to
    /// - Returns: Number of days between dates
    func daysSince(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    /// Calculate weeks between two dates
    /// - Parameter date: The date to calculate difference to
    /// - Returns: Number of weeks between dates
    func weeksSince(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    
    /// Calculate months between two dates
    /// - Parameter date: The date to calculate difference to
    /// - Returns: Number of months between dates
    func monthsSince(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    /// Calculate years between two dates
    /// - Parameter date: The date to calculate difference to
    /// - Returns: Number of years between dates
    func yearsSince(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    // MARK: - Garden-Specific Date Utilities
    
    /// Get the current growing season based on the date
    /// - Returns: The current growing season
    var currentGrowingSeason: GrowingSeason {
        switch self.month {
        case 3...5:
            return .spring
        case 6...8:
            return .summer
        case 9...11:
            return .fall
        default:
            return .winter
        }
    }
    
    /// Calculate days remaining until harvest
    /// - Parameter harvestDate: The expected harvest date
    /// - Returns: Number of days until harvest
    func daysUntilHarvest(harvestDate: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: harvestDate).day ?? 0
    }
    
    /// Calculate growth progress percentage
    /// - Parameters:
    ///   - plantingDate: The date the plant was planted
    ///   - daysToMaturity: The expected days to maturity
    /// - Returns: Growth progress percentage (0-100)
    func growthProgressPercentage(plantingDate: Date, daysToMaturity: Int) -> Double {
        let daysSincePlanting = Double(self.daysSince(plantingDate))
        return min(daysSincePlanting / Double(daysToMaturity) * 100.0, 100.0)
    }
}
