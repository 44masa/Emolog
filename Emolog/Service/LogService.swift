//
//  LogService.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/06/23.
//

import Foundation

struct LogService {
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
        // idがnilでない=データが存在する
        var id: UUID?
        var dateComponents: DateComponents?
        var description: String
        var score: Score?
        
        func getDateString() -> String {
            return "\(dateComponents?.year ?? 0)年\(dateComponents?.month ?? 0)月\(dateComponents?.day ?? 0)日"
        }
    }
    
    private let repository: LogRepository
    static private let calendar = Calendar.current
    
    
    
    
    init(repository:LogRepository) {
        self.repository = repository
    }
    
    public func getLogs(from:Date) -> Array<Log> {
        var result: Array<Log> = []
        
        let rawLogs = self.repository.getLogs(from: from, to: getLastDateOfMonth(for: from)!)
        
        // TODO: 重いのでMap構造にしたい
        getDatesOfMonth(for: from).forEach { dateComponents in
            if(dateComponents == nil) {
                result.append(Log(id: nil, dateComponents: nil, description: ""))
            } else {
                let matchedLog = rawLogs.first { rawLog in
                    let rawLogDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: rawLog.date)
                    return dateComponents!.year == rawLogDateComponents.year && dateComponents!.month  == rawLogDateComponents.month && dateComponents!.day == rawLogDateComponents.day
                }
                
                if(matchedLog != nil) {
                    result.append(Log(id: UUID.init(uuidString: matchedLog!.id), dateComponents: dateComponents!, description: matchedLog!.description, score: Score(rawValue: matchedLog!.score)))
                } else {
                    result.append(Log(id: nil, dateComponents: dateComponents!, description: ""))
                }
            }
        }
        
        return result
    }
}
