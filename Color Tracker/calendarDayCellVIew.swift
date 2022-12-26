//
//  calendarDayCell.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/22/22.
//

import Foundation
import SwiftUI
import ElegantCalendar


struct BoxCell: View {
    var day: String
    private let boxColor = Color(#colorLiteral(red: 0.2235294133424759, green: 0.3607843220233917, blue: 0.41960784792900085, alpha: 1))
    private let textColor = Color(#colorLiteral(red: 0.9450980424880981, green: 0.9490196108818054, blue: 0.9647058844566345, alpha: 1))
    
    @State private var toggledColor: Bool = false
    
    var body: some View {
        Button {
            print("testing")
            toggledColor.toggle()
        } label: {
            ZStack {
                Rectangle()
                    .fill(toggledColor ? boxColor: textColor)
                    .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                    .shadow(
                        color: Color(#colorLiteral(
                            red: 0.007843137718737125,
                            green: 0.06666667014360428,
                            blue: 0.10588235408067703,
                            alpha: 0.15)),
                        radius:2, x:2, y:2)
                Text(day)
                    .font(.body)
                    .foregroundColor(toggledColor ? textColor : boxColor)
            }
        }
    }
}

struct DayCell: View {
    var day: Date
    private let boxColor = Color(#colorLiteral(red: 0.2235294133424759, green: 0.3607843220233917, blue: 0.41960784792900085, alpha: 1))
    private let textColor = Color(#colorLiteral(red: 0.9450980424880981, green: 0.9490196108818054, blue: 0.9647058844566345, alpha: 1))
    
    @State private var toggledColor: Bool = false
    
    var body: some View {
        Button {
            print("testing")
            toggledColor.toggle()
        } label: {
            ZStack {
                Rectangle()
                    .fill(toggledColor ? boxColor: textColor)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                    .shadow(
                        color: Color(#colorLiteral(
                            red: 0.007843137718737125,
                            green: 0.06666667014360428,
                            blue: 0.10588235408067703,
                            alpha: 0.15)),
                        radius:2, x:2, y:2)
                Text(day.getDayOfMonth())
                    .font(.body)
                    .foregroundColor(toggledColor ? textColor : boxColor)
            }
        }
    }
}


struct MonthModel: Decodable {
    let calendar: Calendar
    var date: Date
    var firstDay: Int
    var lastDay: Int
}

struct YearModel: Decodable {
    var months = [Date]()
    var calendar = Calendar(identifier: .iso8601)
    
    init() {
        months = generationDates()
    }
    
    func generationDates() -> [Date] {
        let startDate = Date(timeIntervalSince1970: 60*60*24*365*50)
        let endDate = Date(timeIntervalSince1970: 60*60*24*365*60)
        let interval = DateInterval(start: startDate, end: endDate)
        return calendar.generateMonths(for: interval)
    }
}

public class YearViewModel: ObservableObject {
    var calendar: Calendar = .current
    @Published var yearModel: YearModel
    
    init() {
        yearModel = YearModel()
    }
    
    var months: [Date] {
        return yearModel.months
    }
}



public class calendarViewModel: ObservableObject {
    var calendar: Calendar = .current
    @Published var monthModel: MonthModel
    @Published var yearModel: YearModel
    var months = [Date]()
    
    init() {
        monthModel = MonthModel(
            calendar: calendar,
            date: Date(),
            firstDay: 1,
            lastDay: 1
        )
        yearModel = YearModel()
        
        monthModel.firstDay = calendar.component(.weekday, from: monthModel.date.startOfMonth())
        monthModel.lastDay = calendar.component(.day, from: monthModel.date.endOfMonth())
        
        let startDate = Date(timeIntervalSince1970: 60*60*24*365*50)
        let endDate = Date(timeIntervalSince1970: 60*60*24*365*60)
        let interval = DateInterval(start: startDate, end: endDate)
        
        months = calendar.generateMonths(for: interval)
    }
    
    func firstLastDay() {
        monthModel.firstDay = calendar.component(.weekday, from: monthModel.date.startOfMonth())
        monthModel.lastDay = calendar.component(.day, from: monthModel.date.endOfMonth())
    }
    
    func minus() {
        guard let newDate = calendar.date(
            byAdding: .month,
            value: -1,
            to: monthModel.date
        ) else {
            return
        }
        monthModel.date = newDate
        firstLastDay()
    }

    func add() {
        guard let newDate = calendar.date(
            byAdding: .month,
            value: +1,
            to: monthModel.date
        ) else {
            return
        }
        monthModel.date = newDate
        firstLastDay()
    }
    
    func current() {
        monthModel.date = Date()
        firstLastDay()
        
    }

}

struct monthView: View {
    let columns: [GridItem]
    let month: Date
    let firstDay: Int
    let formatterMonth = DateFormatter()
    
    
    init(columns: [GridItem], month: Date) {
        self.columns = columns
        self.month = month
        firstDay = Calendar.current.component(.weekday, from: month.startOfMonth())
        formatterMonth.dateFormat = "MMM - YYYY"
    }
    
    var body: some View {
        LazyVGrid(
            columns: columns,
            spacing: 0
        ) {
            Section(
                header:
                    HStack {
                        Text(formatterMonth.string(from: month))
                            .font(.title2)
                        Spacer()
                    }
            ) {
                ForEach(1..<firstDay, id: \.self) { _ in
                    Text("")
                }
                ForEach(month.generateDays(), id: \.self) { day in
                    DayCell(day: day)
                }
            }
        }
    }
}



struct CalendarDayCellView: View {
    @ObservedObject var viewModel = YearViewModel()
    
    
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 20), spacing: 0), count: 7)
    private let formatterYear = DateFormatter()
    
    
    
    init() {
        formatterYear.dateFormat = "YYYY"
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 5) {
                HStack {
                    Spacer()
                    Text(formatterYear.string(from: viewModel.months.first!))
                        .font(.title)
                }
                HStack(spacing: 0) {
                    ForEach(viewModel.calendar.veryShortWeekdaySymbols, id: \.self) { day in
                        BoxCell(day: day)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.months, id: \.self) { month in
                    monthView(columns: columns, month: month)
                }
            }
            Spacer()
        }
        .padding()
    }
}


#if DEBUG
struct CalendarDayCellView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDayCellView()
    }
}
#endif
