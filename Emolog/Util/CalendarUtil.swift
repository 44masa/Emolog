//
//  CalendarUtil.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/07/19.
//

import Foundation

let calendar = Calendar.current
let formatter = DateFormatter()

func getFirstDateOfMonth(for date: Date) -> Date? {
    let components = calendar.dateComponents([.year, .month], from: date)
    
    // Now construct a new Date using these components.
    var newComponents = DateComponents()
    newComponents.year = components.year
    newComponents.month = components.month
    newComponents.day = 1
    return calendar.date(from: newComponents)
}


func getLastDateOfMonth(for date: Date) -> Date? {
    let components = calendar.dateComponents([.year, .month], from: date)
    
    // Increment month to get to the next month
    var nextMonthComponents = DateComponents()
    nextMonthComponents.year = components.year
    nextMonthComponents.month = (components.month ?? 0) + 1
    nextMonthComponents.day = 1
    
    if let firstDayOfNextMonth = calendar.date(from: nextMonthComponents) {
        // Subtract one day to get the last day of the current month
        return calendar.date(byAdding: .day, value: -1, to: firstDayOfNextMonth)
    }
    
    return nil
}

func numberOfWeeksInMonth(for date: Date) -> Int {
    if let rangeOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: date) {
        return rangeOfWeeks.count
    } else {
        return 0
    }
}

func getAllDates(ofMonthFrom date: Date) -> [Date] {
    guard let range = calendar.range(of: .day, in: .month, for: date),
          let startDayOfMonth = calendar.date(from: DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: range.lowerBound)) else {
        return []
    }
    
    return (0..<range.count).compactMap {
        calendar.date(byAdding: .day, value: $0, to: startDayOfMonth)
    }
}

func getDatesOfMonth(for date: Date) -> [DateComponents?] {
    var result = Array<Array<Date?>>()
    let numberOfWeeks = numberOfWeeksInMonth(for: date)
    
    for _ in 1...numberOfWeeks {
        result.append(Array(repeating: nil, count: 7))
    }
    
    for el in getAllDates(ofMonthFrom: date) {
        let components = calendar.dateComponents([.year, .month, .day, .weekOfMonth, .weekday], from: el)
        if let weekOfMonth = components.weekOfMonth, let weekday = components.weekday {
            result[weekOfMonth - 1][weekday - 1] = el
        }
    }
    
    return result.flatMap {
        $0.map { el in
            guard let date = el else { return nil }
            return calendar.dateComponents([.year, .month, .day], from: date)
        }
    }
}


func getFormattedDateString(for components: DateComponents?) -> String {
    guard let components = components,
          let date = calendar.date(from: components) else {
        return ""
    }
    formatter.dateFormat = "MMMM d, yyyy"
    return formatter.string(from: date)
}

