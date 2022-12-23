//
//  Color_TrackerApp.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/20/22.
//

import SwiftUI

@main
struct Color_TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            CalendarDayCellView()
        }
    }
}
