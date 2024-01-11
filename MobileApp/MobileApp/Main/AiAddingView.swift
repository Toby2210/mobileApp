//
//  AiAddingView.swift
//  MobileApp
//
//  Created by Toby Pang on 11/1/2024.
//
import SwiftUI
import Foundation

struct AiAddingView: View {
    @State var medications: [Medication] = []   //List of the drugs
    @State var newMedicationName: String
    @State var newMedicationTakingTime = "00:00"
    @Binding var isAdding: Bool
    
    // creat "00:00" until "23:30" option
    let timeIntervals = stride(from: 0, to: 24 * 60, by: 30).map { minutes -> String in
        let hour = minutes / 60
        let minute = minutes % 60
        return String(format: "%02d:%02d", hour, minute)
    }
    
    var body: some View {
        VStack {
            Text("You are adding \(newMedicationName) to your list")
            Text("Please select the taking time")
            Picker("Taking time", selection: $newMedicationTakingTime) {
                ForEach(timeIntervals, id: \.self) { time in
                    Text(time).tag(time)
                }.pickerStyle(MenuPickerStyle())
                    .padding()
            }
            Button(action: {
                if !newMedicationName.isEmpty {
                    //load the record from firebase and send the new record to firebase
                    addNewMedication()
                    isAdding = false
                }
            }) {
                Text("Add")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            loadUserMedications()
        }
    }
    
    func addNewMedication() {
        medications.append(Medication(name: newMedicationName, takingTime: newMedicationTakingTime, isTaken: false, lastModifiedTime: Date()))
        FirebaseManager.shared.saveMedications(medications)
        calculateMedicationPercentage()
        newMedicationName = ""
        newMedicationTakingTime = "00:00"
    }
    // calculate the percentage of today, and send it back to firebase database
    func calculateMedicationPercentage() {
        
        //calculate
        let takenCount = medications.filter { $0.isTaken }.count
        let percentage = Int((Double(takenCount) / Double(medications.count)) * 100)
        
        let currentDate = Date()
        let medicationRecord = MedicationRecord(percentage: percentage, recordDate: currentDate)
        
        var data = [MedicationRecord]()
        data.append(medicationRecord)
        
        //send to firebase
        FirebaseManager.shared.saveMedicationPercentage(data)
        
    }
    func loadUserMedications() {
        FirebaseManager.shared.loadUserMedications { medications in
            DispatchQueue.main.async {
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date())
                
                var updatedMedications = medications
                // check the data is already pass a day or not,
                // if the last modified time is before today, will change the isTaken to false
                for index in 0..<updatedMedications.count {
                    let medication = updatedMedications[index]
                    let medicationDate = calendar.startOfDay(for: medication.lastModifiedTime)
                    
                    if !calendar.isDate(medicationDate, inSameDayAs: today) {
                        updatedMedications[index].isTaken = false
                        updatedMedications[index].lastModifiedTime = today
                    }
                }
                // update the list of the app
                self.medications = updatedMedications
                // update the list and send back to firebase
                FirebaseManager.shared.saveMedications(self.medications)
                calculateMedicationPercentage()
            }
        }
    }
}
