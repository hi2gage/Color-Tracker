//
//  DayHeaderCell.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/26/22.
//

import SwiftUI

struct DayHeaderCell: View {
    var day: String
    private let boxColor = Color(#colorLiteral(red: 0.2235294133424759, green: 0.3607843220233917, blue: 0.41960784792900085, alpha: 1))
    private let textColor = Color(#colorLiteral(red: 0.9450980424880981, green: 0.9490196108818054, blue: 0.9647058844566345, alpha: 1))
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(boxColor)
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
                .foregroundColor(textColor)
        }
    }
}

struct DayHeaderCell_Previews: PreviewProvider {
    static var previews: some View {
        DayHeaderCell(day: "T")
            .frame(minWidth: 100, maxWidth: 30)
    }
}
