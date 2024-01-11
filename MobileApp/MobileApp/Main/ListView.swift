//
//  ListView.swift
//  MobileApp
//
//  Created by Toby Pang on 30/12/2023.
//

import SwiftUI


struct Medication: Identifiable {
    let id = UUID()
    var name: String    //Drug name
    var takingTime: String  //When to take the drug
    var isTaken: Bool   //Is the drug is taken?
    var lastModifiedTime: Date
}

// percentage of each day about taking drug
struct MedicationRecord : Identifiable{
    let id = UUID()
    let percentage: Int
    let recordDate: Date
}
struct ListView: View {
    @State private var medications: [Medication] = []   //List of the drugs
    @State private var medicationRecord: [MedicationRecord] = []
    @State private var isEditing = false
    @State private var isAdding = false
    @State private var newMedicationName = ""
    @State private var newMedicationTakingTime = "00:00"
    
    // creat "00:00" until "23:30" option
    let timeIntervals = stride(from: 0, to: 24 * 60, by: 30).map { minutes -> String in
        let hour = minutes / 60
        let minute = minutes % 60
        return String(format: "%02d:%02d", hour, minute)
    }
    
    var body: some View {
        NavigationView {
            //List of drugs
            VStack {
                List {
                    ForEach(medications) { medication in
                        HStack {
                            Text(medication.name)
                            Spacer()
                            Text(medication.takingTime)
                            if !isEditing {
                                Button(action: {
                                    toggleIsTaken(for: medication)
                                }) {
                                    Image(systemName: medication.isTaken ? "checkmark.square" : "square")
                                }
                            }
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                    
                    if isEditing {
                        EditButton()
                            .padding()
                    }
                }
                //place for adding new drug to drugs list
                HStack {
                    TextField("Name", text: $newMedicationName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Picker("Taking time", selection: $newMedicationTakingTime) {
                        ForEach(timeIntervals, id: \.self) { time in
                            Text(time).tag(time)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    Button(action: {
                        if !newMedicationName.isEmpty {
                            addNewMedication()
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
                .navigationTitle("Medication List")
                .navigationBarItems(trailing: EditButton())
                .onAppear {
                    loadUserMedications()
                }
                
            }
        }
    }
    
    // adding new drug to drugs list
    func addNewMedication() {
        medications.append(Medication(name: newMedicationName, takingTime: newMedicationTakingTime, isTaken: false, lastModifiedTime: Date()))
        FirebaseManager.shared.saveMedications(medications)
        calculateMedicationPercentage()
        isAdding = false
        newMedicationName = ""
        newMedicationTakingTime = "00:00"
    }
    
    // delete a record from the list
    func delete(at offsets: IndexSet) {
        medications.remove(atOffsets: offsets)
        FirebaseManager.shared.saveMedications(medications)
        calculateMedicationPercentage()
    }
    
    // toggle the status of the drug
    func toggleIsTaken(for medication: Medication) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index].isTaken.toggle()
            medications[index].lastModifiedTime = Date()
            FirebaseManager.shared.saveMedications(medications)
        }
        calculateMedicationPercentage()
    }
    
    // move the position of the drug from the list
    func move(from source: IndexSet, to destination: Int) {
        medications.move(fromOffsets: source, toOffset: destination)
        FirebaseManager.shared.saveMedications(medications)
    }
    // get the data from firebase
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
    
}
