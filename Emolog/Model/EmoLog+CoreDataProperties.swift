//
//  EmoLog+CoreDataProperties.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/08/18.
//
//

import Foundation
import CoreData


extension EmoLog {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmoLog> {
        return NSFetchRequest<EmoLog>(entityName: "EmoLog")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var memo: String?
    @NSManaged public var score: Int16
    
}

extension EmoLog : Identifiable {
    
    enum Score: Int, CaseIterable {
        case unknown = 0
        case one = 1
        case two = 2
        case three = 3
        case four = 4
        case five = 5
        
        var emoji: String {
            switch self {
            case .unknown:
                return "?"
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
    
    var scoreEnum: Score? {
        get {
            return Score(rawValue: Int(self.score))
        }
        set {
            self.score = Int16(newValue?.rawValue ?? 0)
        }
    }
    
    var dateComponents: DateComponents? {
        guard let date = self.date else {
            return nil
        }
        
        return Calendar.current.dateComponents([.year, .month, .day], from: date)
    }
    
    var dateString: String? {
        guard let dateComponents = self.dateComponents else {
            return nil
        }
        
        return "\(dateComponents.year!)年\(dateComponents.month!)月\(dateComponents.day!)日"
    }
}
