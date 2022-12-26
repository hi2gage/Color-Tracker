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


struct MonthModel: Decodable {
    let calendar: Calendar
    var date: Date
    var firstDay: Int
    var lastDay: Int
}

public class calendarViewModel: ObservableObject {
    var calendar: Calendar = .current
    @Published var monthModel: MonthModel
    
    init() {
        monthModel = MonthModel(
            calendar: calendar,
            date: Date(),
            firstDay: 1,
            lastDay: 1
        )
        
        monthModel.firstDay = calendar.component(.weekday, from: monthModel.date.startOfMonth())
        monthModel.lastDay = calendar.component(.day, from: monthModel.date.endOfMonth())
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
    let formatterMonth = DateFormatter()
    
    @ObservedObject var viewModel: calendarViewModel
    
    
    init(columns: [GridItem], viewModel: calendarViewModel) {
        self.columns = columns
        self.viewModel = viewModel
        formatterMonth.dateFormat = "MMM"
    }
    
    var body: some View {
        LazyVGrid(
            columns: columns,
            spacing: 0
        ) {
            Section(
                header:
                    HStack {
                        Text(formatterMonth.string(from: viewModel.monthModel.date))
                            .font(.title2)
                        Spacer()
                    }
            ) {
                ForEach(1..<viewModel.monthModel.firstDay, id: \.self) { _ in
                    Text("")
                }
                ForEach(1...viewModel.monthModel.lastDay, id: \.self) { num in
                    BoxCell(day: String(num))
                }
                
                ForEach(1...7, id: \.self) { num in
                    Text("").padding(.horizontal)
                }
            }
        }
    }
}



struct CalendarDayCellView: View {
    @ObservedObject var viewModel = calendarViewModel()
    
    
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 20), spacing: 0), count: 7)
    private let formatterYear = DateFormatter()
    
    
    
    init() {
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
                    Text(formatterYear.string(from: viewModel.monthModel.date))
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
                monthView(columns: columns, viewModel: viewModel)
            }
            Text("Current Day of week: \(viewModel.calendar.component(.day, from: viewModel.monthModel.date))")
            Text("First Day of Month: \(viewModel.monthModel.firstDay)")
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
