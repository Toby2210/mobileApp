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

    func testSortByTakingTimeButtonWithDuplicateTimes() {
        // Create sample medications with duplicate taking times
        let medication1 = Medication(name: "Medication 1", takingTime: "10:00", isTaken: false, lastModifiedTime: Date())
        let medication2 = Medication(name: "Medication 2", takingTime: "09:00", isTaken: false, lastModifiedTime: Date())
        let medication3 = Medication(name: "Medication 3", takingTime: "10:00", isTaken: false, lastModifiedTime: Date())
        
        // Add medications to the list in unsorted order
        listManager.medications = [medication1, medication2, medication3]
        
        // Sort the list by taking time
        listManager.sort()
        
        // Verify that the list is sorted correctly
        XCTAssertEqual(listManager.medications[0].takingTime, "09:00")
        XCTAssertEqual(listManager.medications[1].takingTime, "10:00")
        XCTAssertEqual(listManager.medications[2].takingTime, "10:00")
    }

    func testSortByTakingTimeButtonWithEmptyList() {
        // Create an empty list of medications
        listManager.medications = []
        
        // Sort the list by taking time
        listManager.sort()
        
        // Verify that the list remains empty
        XCTAssertTrue(listManager.medications.isEmpty)
    }

    func testSortByTakingTimeButtonWithSingleMedication() {
        // Create a single medication
        let medication = Medication(name: "Medication 1", takingTime: "10:00", isTaken: false, lastModifiedTime: Date())
        
        // Add the medication to the list
        listManager.medications = [medication]
        
        // Sort the list by taking time
        listManager.sort()
        
        // Verify that the list remains unchanged
        XCTAssertEqual(listManager.medications[0].takingTime, "10:00")
    }

    func testSortByTakingTimeButtonWithMultipleMedicationsWithSameTime() {
        // Create sample medications with the same taking time
        let medication1 = Medication(name: "Medication 1", takingTime: "10:00", isTaken: false, lastModifiedTime: Date())
        let medication2 = Medication(name: "Medication 2", takingTime: "10:00", isTaken: false, lastModifiedTime: Date())
        let medication3 = Medication(name: "Medication 3", takingTime: "10:00", isTaken: false, lastModifiedTime: Date())
        
        // Add medications to the list in unsorted order
        listManager.medications = [medication1, medication2, medication3]
        
        // Sort the list by taking time
        listManager.sort()
        
        // Verify that the list remains unchanged
        XCTAssertEqual(listManager.medications[0].takingTime, "10:00")
        XCTAssertEqual(listManager.medications[1].takingTime, "10:00")
        XCTAssertEqual(listManager.medications[2].takingTime, "10:00")
    }
    
}
