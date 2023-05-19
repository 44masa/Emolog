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
    var dateComponents: DateComponents
    var description: String
    var score: Score
    
    func getDateString() -> String {
        return "\(dateComponents.year ?? 0)年\(dateComponents.month ?? 0)月\(dateComponents.day ?? 0)日"
    }
}
