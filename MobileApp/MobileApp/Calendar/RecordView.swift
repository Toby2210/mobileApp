//
//  RecordView.swift
//  MobileApp
//
//  Created by Toby Pang on 30/12/2023.
//

import SwiftUI

struct RecordView: View {
    @EnvironmentObject var listManager: ListManager
    @EnvironmentObject var dateHolder: DateHolder
    // darw the calendar
    var body: some View
    {
        VStack(spacing: 1)
        {
            DateScrollerView()
                .environmentObject(dateHolder)
                .padding()
            HStack(spacing: 1)
            {
                Text("Sun").dayOfWeek()
                Text("Mon").dayOfWeek()
                Text("Tue").dayOfWeek()
                Text("Wed").dayOfWeek()
                Text("Thu").dayOfWeek()
                Text("Fri").dayOfWeek()
                Text("Sat").dayOfWeek()
            }
            VStack(spacing: 1)
            {
                let daysInMonth = CalendarHelper().daysInMonth(dateHolder.date)
                let firstDayOfMonth = CalendarHelper().firstOfMonth(dateHolder.date)
                let startingSpaces = CalendarHelper().weekDay(firstDayOfMonth)
                let prevMonth = CalendarHelper().minusMonth(dateHolder.date)
                let daysInPrevMonth = CalendarHelper().daysInMonth(prevMonth)
                ForEach(0..<6) { row in
                    HStack(spacing: 1) {
                        ForEach(1..<8) { column in
                            let count = column + (row * 7)
                            CalendarCell(count: count, startingSpaces: startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth, selectedDate: dateHolder.date)
                                .environmentObject(dateHolder)
                        }
                    }
                }
            }
            
        }
        .onAppear {
            listManager.loadData()
            listManager.loadMedicationRecords()
        }
    }
}
extension Text
{
    func dayOfWeek() -> some View
    {
        self.frame(maxWidth: .infinity)
            .padding(.top, 1)
            .lineLimit(1)
    }
}


