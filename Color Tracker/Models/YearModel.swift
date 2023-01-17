//
//  YearModel.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/27/22.
//

import Foundation
import SwiftUI

//class DateColor: Identifiable, ObservableObject {
//    @Published var date: Date
//    @Published var color: Color
//
//    init(date: Date, color: Color) {
//        self.date = date
//        self.color = color
//    }
//}



struct YearModel: Decodable {
    var months = [Date]()
    var calendar = Calendar(identifier: .iso8601)
    
    
    init() {
        months = generationDates()
    }
    
    func generationDates() -> [Date] {
        let startDate = Date.distantFuture.startOfMonth()
        let endDate = Date.distantPast.startOfMonth()
        let interval = DateInterval(start: startDate, end: endDate)
        return calendar.generateMonths(for: interval)
    }
    
}
