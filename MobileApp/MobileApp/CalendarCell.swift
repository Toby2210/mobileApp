//
//  CalendarCell.swift
//  MobileApp
//
//  Created by Toby Pang on 4/1/2024.
//

import SwiftUI

struct CalendarCell: View {
    @EnvironmentObject var dateHolder: DateHolder
    let count: Int
    let startingSpaces: Int
    let daysInMonth: Int
    let daysInPrevMonth: Int
    @State private var medicationPercentage: Int = -1
    let medicationRecords: [MedicationRecord]
    
    
    var body: some View {
        Text(monthStruct().day())
            .foregroundColor(textColor(type: monthStruct().monthType))
            .frame(maxWidth: .infinity, maxHeight: 70)
            .background(cellColor)
    }
    
    func textColor(type: MonthType) -> Color {
        return type == MonthType.Current ? Color.black : Color.gray
    }
    
    func monthStruct() -> MonthStruct {
        let start = startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
        
        if count <= start {
            let day = daysInPrevMonth + count - start
            return MonthStruct(monthType: MonthType.Previous, dayInt: day)
        } else if count - start > daysInMonth {
            let day = count - start - daysInMonth
            return MonthStruct(monthType: MonthType.Next, dayInt: day)
        }
        
        let day = count - start
        return MonthStruct(monthType: MonthType.Current, dayInt: day)
    }
    
    var cellColor: Color {
        if medicationPercentage >= 50 {
            return .yellow
        }else if medicationPercentage == 100 {
            return .green
        }else if medicationPercentage >= 0{
            return .red
        }else {
            return .clear
        }
    }
}
