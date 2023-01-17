//
//  Color_TrackerApp.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/20/22.
//

import SwiftUI

@main
struct Color_TrackerApp: App {
//    @StateObject private var dataController = DataController()
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            CalendarView()
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
    
}
