//
//  calendarDayCell.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/22/22.
//

import Foundation
import SwiftUI

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



struct CalendarDayCellView: View {
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 20), spacing: 0), count: 7)
    
    var body: some View {
        VStack {
            VStack(spacing: 5) {
                Text("Janurary 2020")
                    .font(.title)
                HStack(spacing: 0) {
                    ForEach(daysOfWeekShort.allCases) { day in
                        BoxCell(day: day.rawValue)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(
                    columns: columns,
                    spacing: 0
                ) {
                    Text("")
                    ForEach(0..<30) { num in
                        BoxCell(day: String(num))
                    }
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
