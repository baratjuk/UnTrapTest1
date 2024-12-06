//
//  Item.swift
//  UnTrapTest1
//
//  Created by Andrew Baratjuk on 25.11.2024.
//

import Foundation

final class DayOfWeekItem : Identifiable {
    var title: String
    var state = true
    var id = UUID()
    
    init(_ title: String) {
        self.title = title
    }
    
    static func ==(lhs: DayOfWeekItem, rhs: DayOfWeekItem) -> Bool {
        return lhs.id == rhs.id
    }
}
