//
//  MonthView.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/27/22.
//

import SwiftUI

struct MonthView: View {
    let columns: [GridItem]
    let monthVM: MonthViewModel
    let formatterMonth = DateFormatter()
    
    
    init(columns: [GridItem], month: Date) {
        self.columns = columns
        formatterMonth.dateFormat = "MMM - YYYY"
        monthVM = MonthViewModel(month: month)
    }
    
    var body: some View {
        LazyVGrid(
            columns: columns,
            spacing: 0
        ) {
            Section(
                header:
                    HStack {
                        Text(formatterMonth.string(from: monthVM.month))
                            .font(.title2)
                        Spacer()
                    }
            ) {
                ForEach(1..<monthVM.firstDate, id: \.self) { _ in
                    Text("")
                }
                ForEach(monthVM.allDaysInMonth, id: \.self) { day in
                    DayCell(day: day)
                }
                .id(UUID())
            }
        }
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        
        let columns: [GridItem] = Array(
            repeating: GridItem(.flexible(minimum: 20), spacing: 0),
            count: 7
        )
        
        MonthView(columns: columns, month: Date())
            .padding()
    }
}
