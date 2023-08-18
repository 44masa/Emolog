//
//  EmologApp.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/04/21.
//

import SwiftUI

@main
struct EmologApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            CalendarView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onChange(of: scenePhase) { _ in
                    persistenceController.save()
                }
        }
    }
}
