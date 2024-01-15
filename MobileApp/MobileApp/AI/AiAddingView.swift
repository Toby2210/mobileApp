//
//  AiAddingView.swift
//  MobileApp
//
//  Created by Toby Pang on 11/1/2024.
//
import SwiftUI
import Foundation

struct AiAddingView: View {
    @EnvironmentObject var listManager: ListManager
    @State var newItem: String =  ""
    @Binding var isAdding: Bool
    var body: some View {
        VStack {
            Text("You are adding \(newItem) to your list")
            Text("Please select the taking time")
            Picker("Taking time", selection: $listManager.newMedicationTakingTime) {
                ForEach(listManager.timeIntervals, id: \.self) { time in
                    Text(time).tag(time)
                }.pickerStyle(MenuPickerStyle())
                    .padding()
            }
            Button(action: {
                if !newItem.isEmpty {
                    //load the record from firebase and send the new record to firebase
                    listManager.newMedicationName = newItem
                    listManager.addNewMedication()
                    isAdding = false
                }
            }) {
                Text("Add to Reminder list")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            listManager.loadUserMedications()
        }
    }
}
