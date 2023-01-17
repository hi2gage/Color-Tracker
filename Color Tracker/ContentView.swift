//
//  ContentView.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/20/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var dateColors: FetchedResults<DateColor>
    
    var body: some View {
        
        VStack {
            CalendarView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
