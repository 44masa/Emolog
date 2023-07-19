//
//  LogRepository.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/06/23.
//

import Foundation

struct LogRepository {
    struct Log {
        var id: String
        var date: Date
        var description: String
        var score: Int
    }
    func getLogs(from: Date, to:Date) -> Array<Log> {
        return [Log(id: UUID().uuidString, date: Date(), description: "良い一日だった", score: 5)]
    }
}
