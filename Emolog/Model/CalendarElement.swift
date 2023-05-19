//
//  CalendarElement.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/05/19.
//

import Foundation

class CalendarElement {
    struct Element: Identifiable {
        var id:UUID
        var dateComponents: DateComponents?
        var log: Log?
    }
    
    private static func getFirstDateOfMonth(for date: Date) -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        // Now construct a new Date using these components.
        var newComponents = DateComponents()
        newComponents.year = components.year
        newComponents.month = components.month
        newComponents.day = 1
        return calendar.date(from: newComponents)
    }
    
    private static func getLastDateOfMonth(for date: Date) -> Date? {
        let calendar = Calendar.current
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
    
    private static func numberOfWeeksInMonth(for date: Date) -> Int {
        let calendar = Calendar.current
        if let rangeOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: date) {
            return rangeOfWeeks.count
        } else {
            return 0
        }
    }
    
    private static func getAllDates(ofMonthFrom date: Date) -> [Date] {
        let calendar = Calendar.current
        
        let range = calendar.range(of: .day, in: .month, for: date)
        let startDayOfMonth = calendar.date(from: DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: range?.lowerBound))!
        
        return (0..<(range?.count ?? 0)).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startDayOfMonth)
        }
    }
    
    static func getDatesOfMonth(for date:Date) -> Array<Array<Element?>>{
        let calendar = Calendar.current
        var result = Array<Array<Element?>>()
        for _ in 1 ... numberOfWeeksInMonth(for: date) {
            result.append(Array([nil,nil,nil,nil,nil,nil,nil]))
        }
        
        for el in getAllDates(ofMonthFrom: date) {
            let components = calendar.dateComponents([.year, .month,.day, .weekOfMonth, .weekday],from:el)
            result[components.weekOfMonth!-1][components.weekday!-1] = Element(id:UUID(),dateComponents: components, log: Log(id: 1, dateComponents: components, description: "hoge", score: Score.five))
            
        }
        
        return result
    }
    
    static func getFlattenedDatesOfMonth(for date:Date) -> Array<Element> {
        return getDatesOfMonth(for: date).flatMap{
            $0.map{ el in
                return el ?? Element(id:UUID())
            }
        }
    }
}


