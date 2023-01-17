//
//  PersistenceController.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/27/22.
//

import Foundation
import CoreData
import SwiftUI

struct PersistenceController {
    // A singleton for our entire app to use
    static let shared = PersistenceController()

    // Storage for Core Data
    let container: NSPersistentContainer

    // A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        
        let controller = PersistenceController(inMemory: true)

        // Create 10 example programming languages.
        let dateColor = DateColor(context: controller.container.viewContext)
        dateColor.dateAsString = formatter1.string(from: Date())
        dateColor.colorAsHex = "#d68c45"
        
        
        let dateColor1 = DateColor(context: controller.container.viewContext)
        dateColor1.dateAsString = formatter1.string(from: Date().endOfMonth())
        
        dateColor1.colorAsHex = "#7d6167"
        
        
        let dateColor2 = DateColor(context: controller.container.viewContext)
        dateColor2.dateAsString = formatter1.string(from: Date().startOfMonth())
        dateColor2.colorAsHex = "#37ff8b"

        return controller
    }()

    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
    init(inMemory: Bool = false) {
        // If you didn't name your model Main you'll need
        // to change this name below.
        container = NSPersistentContainer(name: "Color_Tracker")

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
                // Show some error here
            }
        }
    }
}
