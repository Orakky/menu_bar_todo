//
//  TodoItem.swift
//  menu_bar_todo
//
//  Created by 啊！是松松松 on 2026/3/17.
//

import Foundation

struct TodoItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var text: String
    var isCompleted: Bool = false
    var date: Date
    var createdAt: Date = Date()
    var completedAt: Date? = nil
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter.string(from: date)
}
