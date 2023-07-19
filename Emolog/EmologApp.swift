//
//  EmologApp.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/04/21.
//

import SwiftUI

@main
struct EmologApp: App {
    var body: some Scene {
        WindowGroup {
            CalendarView(service: LogService(repository: LogRepository()))
        }
    }
}
