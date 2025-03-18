//
//  Item.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
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
