//
//  StatusBarManager.swift
//  menu_bar_todo
//
//  Created by 啊！是松松松 on 2026/3/17.
//

import SwiftUI
import AppKit
import Combine
import ServiceManagement

class StatusBarManager: NSObject, ObservableObject {
    @Published var statusText: String = ""
    @Published var todoItems: [TodoItem] = []
    @Published var selectedDate: Date = Date()
    @Published var menuIsOpen: Bool = false
    private var timer: Timer?
    private var currentTodoIndex: Int = 0
    @Published var currentStatusBarText: String = ""
    
    func openSettingsWindow() {
        // 创建设置窗口
        let settingsView = SettingsView(statusBarManager: self)
        let hostingController = NSHostingController(rootView: settingsView)
        
        // 获取当前屏幕的主窗口或创建新窗口
        let window = NSWindow(
            contentViewController: hostingController
        )
        window.setContentSize(NSSize(width: 400, height: 200))
        window.center()
        window.title = "设置"
        
        // 设置窗口级别为浮动，确保在所有窗口前面
        window.level = .floating
        
        // 设置窗口样式
        window.styleMask = [.titled, .closable]
        
        // 激活应用程序，确保窗口获得焦点
        NSApp.activate(ignoringOtherApps: true)
        
        // 显示窗口
        window.makeKeyAndOrderFront(nil)
        
        // 让窗口控制器保持活跃，防止被释放
        hostingController.view.window?.makeKeyAndOrderFront(nil)
    }
    

    
    override init() {
        super.init()
        loadTodoItems()
        startTodoRotation()
    }
    
    private func startTodoRotation() {
        // 停止现有的定时器
        timer?.invalidate()
        
        // 获取当前日期的未完成待办事项
        let incompleteTodos = getTodoItemsForCurrentDate().filter { !$0.isCompleted }
        
        // 如果有未完成的待办事项，启动定时器
        if !incompleteTodos.isEmpty {
            currentTodoIndex = 0
            // 立即显示第一个待办事项
            if let firstTodo = incompleteTodos.first {
                currentStatusBarText = firstTodo.text
            }
            
            // 启动定时器，每3秒切换一次
            timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                let incompleteTodos = self.getTodoItemsForCurrentDate().filter { !$0.isCompleted }
                if !incompleteTodos.isEmpty {
                    self.currentTodoIndex = (self.currentTodoIndex + 1) % incompleteTodos.count
                    self.currentStatusBarText = incompleteTodos[self.currentTodoIndex].text
                } else {
                    // 如果没有未完成的待办事项，停止定时器
                    self.timer?.invalidate()
                    self.timer = nil
                    self.currentStatusBarText = ""
                }
            }
        } else {
            // 如果没有未完成的待办事项，清空状态栏文本
            currentStatusBarText = ""
        }
    }
    
    private func stopTodoRotation() {
        timer?.invalidate()
        timer = nil
    }
    
    func addTodoItem(_ text: String) {
        if !text.isEmpty {
            let newItem = TodoItem(text: text, isCompleted: false, date: selectedDate)
            todoItems.append(newItem)
            saveTodoItems()
            startTodoRotation()
        }
    }
    
    func selectTodoItem(_ item: TodoItem) {
        statusText = item.text
        currentStatusBarText = item.text
    }
    
    func toggleTodoItem(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            todoItems[index].isCompleted.toggle()
            // 记录完成时间
            if todoItems[index].isCompleted {
                todoItems[index].completedAt = Date()
            } else {
                todoItems[index].completedAt = nil
            }
            saveTodoItems()
            startTodoRotation()
        }
    }
    
    // 延期待办事项到第二天
    func postponeTodoItem(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            let calendar = Calendar.current
            // 将日期设置为第二天
            if let nextDay = calendar.date(byAdding: .day, value: 1, to: todoItems[index].date) {
                todoItems[index].date = nextDay
                saveTodoItems()
            }
        }
    }
    
    func removeTodoItem(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            todoItems.remove(at: index)
            saveTodoItems()
            startTodoRotation()
        }
    }
    
    func getTodoItemsForCurrentDate() -> [TodoItem] {
        let calendar = Calendar.current
        return todoItems.filter { item in
            calendar.isDate(item.date, inSameDayAs: selectedDate)
        }
    }
    
    @Published var dateRangeOffset: Int = 0
    
    enum DateType {
        case previousDay
        case today
        case nextDay
    }
    
    func selectDate(_ dateType: DateType) {
        selectedDate = getDate(dateType)
        startTodoRotation()
    }
    
    func getDate(_ dateType: DateType) -> Date {
        let calendar = Calendar.current
        let today = Date()
        
        switch dateType {
        case .previousDay:
            return calendar.date(byAdding: .day, value: -1 + dateRangeOffset, to: today) ?? today
        case .today:
            return calendar.date(byAdding: .day, value: dateRangeOffset, to: today) ?? today
        case .nextDay:
            return calendar.date(byAdding: .day, value: 1 + dateRangeOffset, to: today) ?? today
        }
    }
    
    func isSelectedDate(_ dateType: DateType) -> Bool {
        let calendar = Calendar.current
        let date = getDate(dateType)
        return calendar.isDate(selectedDate, inSameDayAs: date)
    }
    
    func shiftDateRange(by days: Int) {
        dateRangeOffset += days
        startTodoRotation()
    }
    
    private func saveTodoItems() {
        if let encoded = try? JSONEncoder().encode(todoItems) {
            UserDefaults.standard.set(encoded, forKey: "todoItems")
        }
    }
    
    private func loadTodoItems() {
        if let data = UserDefaults.standard.data(forKey: "todoItems"),
           let items = try? JSONDecoder().decode([TodoItem].self, from: data) {
            todoItems = items
        }
    }
    
    // 检查是否设置了开机启动
    func isStartAtLogin() -> Bool {
        let service = SMAppService.mainApp
        return service.status == .enabled
    }
    
    // 设置开机启动状态
    func setStartAtLogin(_ enabled: Bool) {
        let service = SMAppService.mainApp
        do {
            if enabled {
                try service.register()
            } else {
                try service.unregister()
            }
        } catch {
            print("Error setting login item: \(error)")
        }
        // 保存设置到UserDefaults
        UserDefaults.standard.set(enabled, forKey: "startAtLogin")
    }
}
