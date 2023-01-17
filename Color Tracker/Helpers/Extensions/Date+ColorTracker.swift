//
//  Date+ColorTracker.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/27/22.
//

import Foundation

extension Date {
     /**
      Formats a Date

      - parameters format: (String) for eg dd-MM-yyyy hh-mm-ss
      */
     func format(format:String = "dd-MM-yyyy hh-mm-ss") -> Date {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = format
         let dateString = dateFormatter.string(from: self)
         if let newDate = dateFormatter.date(from: dateString) {
             return newDate
         } else {
             return self
         }
     }
    
    
 }
