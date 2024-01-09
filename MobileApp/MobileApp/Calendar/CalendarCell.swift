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
    let selectedDate: Date
    
    // draw the calendar
    var body: some View {
        Group {
            if monthStruct().monthType == .Current {
                Text(monthStruct().day())
                    .foregroundColor(textColor(type: monthStruct().monthType))
                    .frame(maxWidth: .infinity, maxHeight: 70)
                    .background(cellColor())
            } else {
                Text("")
                    .frame(maxWidth: .infinity, maxHeight: 70)
                    .background(Color.clear)
            }
        }
    }
    
    func textColor(type: MonthType) -> Color {
        if type == MonthType.Current {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                return Color.white
            } else {
                return Color.black
            }
        } else {
            return Color.gray
        }
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
    
    // Get the record and set different color to the calendar
    func cellColor() -> Color {
        let currentDate = monthStruct()
        let selectedYearMonth = CalendarHelper().monthYearString(selectedDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for medicationRecord in medicationRecords {
            let recordDate = dateFormatter.string(from: medicationRecord.recordDate)
            
            guard let date = dateFormatter.date(from: recordDate) else {
                continue
            }
            
            let recordYearMonth = CalendarHelper().monthYearString(date)
            if recordYearMonth == selectedYearMonth {
                let medicationDay = CalendarHelper().dayOfMonth(date)
                if medicationDay == currentDate.dayInt {
                    let medicationPercentage = medicationRecord.percentage
                    if medicationPercentage == 100 {
                        return .green
                    } else if medicationPercentage >= 50 {
                        return .yellow
                    } else {
                        return .red
                    }
                }
            }
        }
        
        return .clear
    }
}
