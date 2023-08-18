//
//  PersistenceController.swift
//  Emolog
//
//  Created by 荒武禎将 on 2023/08/18.
//

import CoreData

struct PersistenceController {
    // A singleton for our entire app to use
    static let shared = PersistenceController()
    
    // Storage for Core Data
    let container: NSPersistentContainer
    
    // A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        
        let emoLog = EmoLog(context: controller.container.viewContext)
        emoLog.id = UUID()
        emoLog.date = Date()
        emoLog.score = 5
        emoLog.memo = "It was a nice day."
        try? controller.container.viewContext.save()
        return controller
    }()
    
    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
    init(inMemory: Bool = false) {
        // If you didn't name your model Main you'll need
        // to change this name below.
        container = NSPersistentContainer(name: "EmoLog")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("CoreData failed to load: \(error.localizedDescription)")
            }
        }
    }
}
