//
//  Item.swift
//  MobileApp
//
//  Created by Toby Pang on 19/12/2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
