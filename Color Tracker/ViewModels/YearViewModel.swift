//
//  YearViewModel.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/27/22.
//

import Foundation
import SwiftUI

public class YearViewModel: ObservableObject {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var calendar: Calendar = .current
    
    @Published var yearModel: YearModel
    
    init() {
        yearModel = YearModel()
    }
    
    var months: [Date] {
        let temp = yearModel.months
        return temp
    }
    
    var currentMonth: Date {
        let date = Date()
        let month = date.startOfMonth()
        return month
    }
}
