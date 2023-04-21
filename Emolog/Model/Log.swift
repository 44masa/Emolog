//
//  Log.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/04/21.
//

import Foundation

enum Score: Int, CaseIterable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    
    var emoji: String {
            switch self {
            case .one:
                return "😖"
            case .two:
                return "😕"
            case .three:
                return "😐"
            case .four:
                return "🙂"
            case .five:
                return "😄"
            }
        }
}


struct Log: Identifiable {
    var id: Int
    var date: Date
    var description: String
    var score: Score
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        return formatter
    }()
    
    func getDateString() -> String {
        return Self.dateFormatter.string(from: self.date)
    }
}
