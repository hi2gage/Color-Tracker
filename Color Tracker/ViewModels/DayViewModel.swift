//
//  DayViewModel.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/27/22.
//

import Foundation

struct DayViewModel {
    let day: Date
    
    var dayOfMonth: Int {
        day.getDayOfMonth()
    }
}
