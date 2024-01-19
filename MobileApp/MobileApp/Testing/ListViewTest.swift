//
//  ListViewTest.swift
//  MobileAppTests
//
//  Created by Toby Pang on 18/1/2024.
//

import XCTest
@testable import MobileApp

class ListViewTests: XCTestCase {
    var listManager: ListManager!
    
    override func setUp() {
        super.setUp()
        listManager = ListManager()
    }
    
    override func tearDown() {
        listManager = nil
        super.tearDown()
    }
    func testSortByTakingTimeButton() {
        // Reset the list
        listManager.medications = []
        // Create sample medications with different taking times
        let medication1 = Medication(name: "Medication 1", takingTime: "10:00", isTaken: false, lastModifiedTime: Date())
        let medication2 = Medication(name: "Medication 2", takingTime: "09:00", isTaken: false, lastModifiedTime: Date())
        let medication3 = Medication(name: "Medication 3", takingTime: "11:00", isTaken: false, lastModifiedTime: Date())
        
        // Add medications to the list in unsorted order
        listManager.medications = [medication1, medication2, medication3]
        
        // Sort the list by taking time
        listManager.sort()
        
        // Verify that the list is sorted correctly
        XCTAssertEqual(listManager.medications[0].takingTime, "09:00")
        XCTAssertEqual(listManager.medications[1].takingTime, "10:00")
        XCTAssertEqual(listManager.medications[2].takingTime, "11:00")
    }
    
    func testAddNewMedication() {
        // Reset the list
        listManager.medications = []
        // Arrange
        let initialCount = listManager.medications.count
        let medicationName = "Medication A"
        let medicationTakingTime = "08:00"
        
        // Act
        listManager.newMedicationName = medicationName
        listManager.newMedicationTakingTime = medicationTakingTime
        listManager.addNewMedication()
        
        // Assert
        XCTAssertEqual(listManager.medications.count, initialCount + 1, "Medication count should increase by 1")
        
        let addedMedication = listManager.medications.last
        XCTAssertEqual(addedMedication?.name, medicationName, "The name of the added medication should match")
        XCTAssertEqual(addedMedication?.takingTime, medicationTakingTime, "The taking time of the added medication should match")
        XCTAssertFalse(addedMedication?.isTaken ?? true, "The added medication should have 'isTaken' set to false")
    }
    
    func testMoveMedication() {
        // Reset the list
        listManager.medications = []
        
        // Arrange
        let medicationA = Medication(name: "Medication A", takingTime: "08:00", isTaken: false, lastModifiedTime: Date())
        let medicationB = Medication(name: "Medication B", takingTime: "12:00", isTaken: false, lastModifiedTime: Date())
        let medicationC = Medication(name: "Medication C", takingTime: "16:00", isTaken: false, lastModifiedTime: Date())
        
        listManager.medications = [medicationA, medicationB, medicationC]
        
        XCTAssertEqual(listManager.medications[0].name, "Medication A", "The first medication should be Medication A")
        XCTAssertEqual(listManager.medications[1].name, "Medication B", "The second medication should be Medication B")
        XCTAssertEqual(listManager.medications[2].name, "Medication C", "The third medication should be Medication C")
        
        // Act
        listManager.move(from: IndexSet(integer: 0), to: 3)
        
        XCTAssertEqual(self.listManager.medications[0].name, "Medication B", "The first medication should be Medication B")
        XCTAssertEqual(self.listManager.medications[1].name, "Medication C", "The second medication should be Medication C")
        XCTAssertEqual(self.listManager.medications[2].name, "Medication A", "The third medication should be Medication A")
    }
    
    func testDeleteMedication() {
        // Reset the list
        listManager.medications = []
        // Arrange
        let medicationA = Medication(name: "Medication A", takingTime: "08:00", isTaken: false, lastModifiedTime: Date())
        let medicationB = Medication(name: "Medication B", takingTime: "12:00", isTaken: false, lastModifiedTime: Date())
        let medicationC = Medication(name: "Medication C", takingTime: "16:00", isTaken: false, lastModifiedTime: Date())
        
        listManager.medications = [medicationA, medicationB, medicationC]
        
        // Act
        listManager.delete(at: IndexSet(integer: 1))
        
        // Assert
        XCTAssertEqual(listManager.medications.count, 2, "Medication count should decrease by 1")
        XCTAssertEqual(listManager.medications[0].name, "Medication A", "The first medication should be Medication A")
        XCTAssertEqual(listManager.medications[1].name, "Medication C", "The second medication should be Medication C")
    }
    
}
