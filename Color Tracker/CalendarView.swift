//
//  CalendarView.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/22/22.
//

import SwiftUI

struct CalendarView: View {
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
                        DayHeaderCell(day: day)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            ScrollViewReader { value in
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.months, id: \.self) { month in
                        MonthView(columns: columns, month: month)
                    }
                }
//                .onAppear {
//                    value.scrollTo(viewModel.months[66], anchor: .top)
//                }
            }
            Spacer()
        }
        .padding()
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
