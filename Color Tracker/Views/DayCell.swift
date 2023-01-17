//
//  DayCell.swift
//  Color Tracker
//
//  Created by Gage Halverson on 12/27/22.
//

import SwiftUI
import CoreData

struct DayCell: View {


    var day: Date
    private let boxColor = Color(#colorLiteral(red: 0.2235294133424759, green: 0.3607843220233917, blue: 0.41960784792900085, alpha: 1))
    private let textColor = Color(#colorLiteral(red: 0.9450980424880981, green: 0.9490196108818054, blue: 0.9647058844566345, alpha: 1))
    private let orangeColor = Color(#colorLiteral(red: 0.8392156958580017, green: 0.5490196347236633, blue: 0.2705882489681244, alpha: 1))
    private let greenColor = Color(#colorLiteral(red: 0.21568627655506134, green: 1, blue: 0.545098066329956, alpha: 1))
    
    
    @State private var toggledColor: Bool = false
    
    let formatter1 = DateFormatter()
    
    init(day: Date) {
        self.day = day
        formatter1.dateStyle = .short
    }
    
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.dateAsString)]
    ) var actualColor: FetchedResults<DateColor>
    
    @Environment(\.managedObjectContext) private var viewContext

    
    
    var body: some View {
        Button {
            print("testing")
            toggledColor.toggle()
            sendColor(for: day, color: toggledColor ? orangeColor : greenColor)
        } label: {
            ZStack {
                Rectangle()
                    .fill(color(day: day, result: actualColor))
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
                Text(String(day.getDayOfMonth()))
                    .font(.body)
                    .foregroundColor(boxColor)
            }
        }
    }
    
    func color(day: Date, result: FetchedResults<DateColor>) -> Color {
        let color = result.first { item in
            item.dateAsString == formatter1.string(from: day)
        }
        
        guard let color, let returnColor = color.colorAsHex else {
            print("Order Retreved: DOESN'T Exist")
            return Color(hex: "#f1f2f6")
        }
        print("Order Retreved: \(returnColor)")
        return Color(hex: returnColor)
    }
    
    func sendColor(for date: Date, color: Color) {
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let colorDate = DateColor(context: viewContext)
        colorDate.dateAsString = formatter1.string(from: date)
        colorDate.colorAsHex = color.toHex()
        do {
            try viewContext.save()
            print("Order saved: \(colorDate.dateAsString) | \(colorDate.colorAsHex)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
}


struct DayCell_Previews: PreviewProvider {
    static var previews: some View {
        DayCell(day: Date())
            .frame(minWidth: 100, maxWidth: 30)
    }
}
