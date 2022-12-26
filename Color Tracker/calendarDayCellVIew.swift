//
//  calendarDayCell.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/22/22.
//

import Foundation
import SwiftUI
import ElegantCalendar

enum daysOfWeekLong: String, CaseIterable, Identifiable  {
    case sunday = "Sun"
    case monday = "Mon"
    case tuesday = "Tues"
    case wednesday = "Wed"
    case thursday = "Thur"
    case friday = "Fri"
    case saturday = "Sat"
    var id: String { return self.rawValue }
}

enum daysOfWeekShort: String, CaseIterable, Identifiable  {
    case sunday = "S"
    case monday = "M"
    case tuesday = "T"
    case wednesday = "W"
    case thursday = "Th"
    case friday = "F"
    case saturday = "ST"
    
    var id: String { return self.rawValue }
}

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

func makeDays(calendar: Calendar, date: Date) -> [Date] {
    guard let monthInterval = calendar.dateInterval(of: .month, for: date),
          let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
          let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
    else {
        return []
    }

    let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
    return calendar.generateDays(for: dateInterval)
}


struct monthModel: Decodable {
    let calendar: Calendar
    var date: Date
    var firstDay: Int
    var lastDay: Int
}

public class calendarViewModel: ObservableObject {
    var calendar: Calendar = .current
    @Published var month: monthModel {
        didSet {
            print(month)
        }
    }
    
    init() {
        month = monthModel(
            calendar: calendar,
            date: Date(),
            firstDay: 1,
            lastDay: 1
        )
        
        month.firstDay = calendar.component(.weekday, from: month.date.startOfMonth())
        month.lastDay = calendar.component(.day, from: month.date.endOfMonth())
    }
    
    func firstLastDay() {
        month.firstDay = calendar.component(.weekday, from: month.date.startOfMonth())
        month.lastDay = calendar.component(.day, from: month.date.endOfMonth())
    }
    
    func minus() {
        guard let newDate = calendar.date(
            byAdding: .month,
            value: -1,
            to: month.date
        ) else {
            return
        }
        month.date = newDate
        firstLastDay()
    }

    func add() {
        guard let newDate = calendar.date(
            byAdding: .month,
            value: +1,
            to: month.date
        ) else {
            return
        }
        month.date = newDate
        firstLastDay()
    }
    
    func current() {
        month.date = Date()
        firstLastDay()
        
    }

}



struct CalendarDayCellView: View {
    @ObservedObject var viewModel = calendarViewModel()
    
    
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 20), spacing: 0), count: 7)
    private let formatterMonth = DateFormatter()
    private let formatterYear = DateFormatter()
    
    
    
    init() {
        formatterMonth.dateFormat = "MMM"
        formatterYear.dateFormat = "YYYY"
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 5) {
                HStack {
                    Button {
                        viewModel.minus()
                    } label: {
                        Label(
                            title: { Text("Previous") },
                            icon: { Image(systemName: "chevron.left") }
                        )
                        .labelStyle(IconOnlyLabelStyle())
                    }
                    
                    Button {
                        viewModel.current()
                    } label: {
                        Label(
                            title: { Text("Next") },
                            icon: { Image(systemName: "square") }
                        )
                        .labelStyle(IconOnlyLabelStyle())
                        .padding(.horizontal)
                    }
                    
                    Button {
                        viewModel.add()
                    } label: {
                        Label(
                            title: { Text("Next") },
                            icon: { Image(systemName: "chevron.right") }
                        )
                        .labelStyle(IconOnlyLabelStyle())
                    }
                    Spacer()
                    Text(formatterYear.string(from: viewModel.month.date))
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
                LazyVGrid(
                    columns: columns,
                    spacing: 0
                ) {
                    Section(
                        header:
                            HStack {
                                Text(formatterMonth.string(from: viewModel.month.date))
                                    .font(.title2)
                                Spacer()
                            }
                    ) {
                        ForEach(1..<viewModel.month.firstDay, id: \.self) { _ in
                            Text("")
                        }
                        ForEach(1...viewModel.month.lastDay, id: \.self) { num in
                            BoxCell(day: String(num))
                        }
                    }
                }
            }
            Text("Day of week: \(viewModel.calendar.component(.day, from: viewModel.month.date))")
            Text("First Day of Month: \(viewModel.month.firstDay)")
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
