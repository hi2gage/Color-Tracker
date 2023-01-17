//
//  MonthViewModel.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/27/22.
//

import Foundation

struct MonthViewModel {
    let month: Date
    
    var firstDate: Int {
        return Calendar.current.component(.weekday, from: month.startOfMonth())
    }
    
    var allDaysInMonth: [Date] {
        return month.generateDays()
    }
}
