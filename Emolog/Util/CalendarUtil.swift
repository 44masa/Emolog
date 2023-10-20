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
    let range = calendar.range(of: .day, in: .month, for: date)
    let startDayOfMonth = calendar.date(from: DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: range?.lowerBound))!
    
    return (0..<(range?.count ?? 0)).compactMap {
        calendar.date(byAdding: .day, value: $0, to: startDayOfMonth)
    }
}

func getDatesOfMonth(for date:Date) -> [DateComponents?]{
    var result = Array<Array<Date?>>()
    for _ in 1 ... numberOfWeeksInMonth(for: date) {
        result.append(Array([nil,nil,nil,nil,nil,nil,nil]))
    }
    
    for el in getAllDates(ofMonthFrom: date) {
        let components = calendar.dateComponents([.year, .month,.day, .weekOfMonth, .weekday],from:el)
        result[components.weekOfMonth!-1][components.weekday!-1] = el
    }
    
    return result.flatMap{
        $0.map{ el in
          return el != nil ? calendar.dateComponents([.year, .month, .day], from: el!) : nil
        }
    }
}

func getFormattedDateString(for components: DateComponents?) -> String {
    if(components == nil){
        return ""
    }
    let date = calendar.date(from: components!)
    formatter.dateFormat = "yyyy年MM月dd日"
    return formatter.string(from: date!)
}
