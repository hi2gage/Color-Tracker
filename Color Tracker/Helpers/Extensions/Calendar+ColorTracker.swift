//
//  Calendar+ColorTracker.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/22/22.
//

import Foundation

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func getDayOfMonth() -> Int {
        let components = Calendar.current.dateComponents([.day,.month,.year], from: self)
        let day: Int = components.day!
        return day
    }
    
    func generateDays() -> [Date] {
        Calendar.current.generateDays(for: DateInterval(start: self.startOfMonth(), end: self.endOfMonth()))
    }
}

extension Calendar {
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]

        enumerateDates(
            startingAfter: dateInterval.start.startOfMonth(),
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }

            guard date < dateInterval.end else {
                stop = true
                return
            }

            dates.append(date)
        }

        return dates
    }

    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }
    
    func generateMonths(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents([.day], from: dateInterval.start)
        )
    }
}
