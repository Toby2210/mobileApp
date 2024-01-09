//
//  DateScrollerView.swift
//  MobileApp
//
//  Created by Toby Pang on 4/1/2024.
//

import SwiftUI

struct DateScrollerView: View
{
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View
    {
        HStack
        {
            Spacer()
            Button(action: previousMonth)
            {
                Image(systemName: "arrow.left")
                    .imageScale(.large)
                    .font(Font.title.weight(.bold))
            }
            Text(CalendarHelper().monthYearString(dateHolder.date))
                .font(.title)
                .bold()
                .animation(.none)
            Button(action: nextMonth)
            {
                Image(systemName: "arrow.right")
                    .imageScale(.large)
                    .font(Font.title.weight(.bold))
            }
            
            Spacer()
        }
    }
    
    func previousMonth() {
        dateHolder.date = CalendarHelper().minusMonth(dateHolder.date)
        dateHolder.objectWillChange.send()
    }

    func nextMonth() {
        dateHolder.date = CalendarHelper().plusMonth(dateHolder.date)
        dateHolder.objectWillChange.send() 
    }
    
    
}

