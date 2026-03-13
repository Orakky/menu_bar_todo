//
//  Item.swift
//  menu_bar_todo
//
//  Created by 啊！是松松松 on 2026/3/13.
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
