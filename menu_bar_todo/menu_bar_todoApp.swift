//
//  menu_bar_todoApp.swift
//  menu_bar_todo
//
//  Created by 啊！是松松松 on 2026/3/13.
//

import SwiftUI
import AppKit

// 导入模型和管理器
import Foundation


@main
struct menu_bar_todoApp: App {
    @StateObject private var statusBarManager = StatusBarManager()

    var body: some Scene {
        MenuBarExtra(statusBarManager.currentStatusBarText.isEmpty ? ">^<" : statusBarManager.currentStatusBarText) {
            VStack(spacing: 12) {
                // 顶部设置按钮
                HStack {
                    Spacer()
                    Button(action: {
                        // 打开设置窗口
                        statusBarManager.openSettingsWindow()
                        // 关闭菜单下拉框
                        NSApp.hide(nil)
                    }) {
                        Image(systemName: "gear")
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                            .padding(6)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(6)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // 输入区域
                VStack(spacing: 6) {
                    Text("添加待办事项")
                        .font(.headline)
                        .foregroundColor(.primary)
                    HStack(spacing: 6) {
                        TextField("输入待办内容...", text: $statusBarManager.statusText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(6)
                            .background(Color.secondary.opacity(0.05))
                            .cornerRadius(6)
                            .onChange(of: statusBarManager.statusText) {
                                statusBarManager.currentStatusBarText = statusBarManager.statusText
                            }
                        
                        Button(action: {
                            statusBarManager.addTodoItem(statusBarManager.statusText)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .padding(4)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                // 统计信息
                HStack {
                    Text("待办统计: ")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(String(statusBarManager.getTodoItemsForCurrentDate().filter { !$0.isCompleted }.count))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                    Text("/")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(String(statusBarManager.getTodoItemsForCurrentDate().filter { $0.isCompleted }.count))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    Spacer()
                }
                
                // 日期选择器
                VStack(spacing: 6) {
                    Text("选择日期")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack(spacing: 3) {
                        Button(action: {
                            statusBarManager.shiftDateRange(by: -1)
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 12))
                                .foregroundColor(.primary)
                                .padding(4)
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            statusBarManager.selectDate(.previousDay)
                        }) {
                            Text(formatDate(statusBarManager.getDate(.previousDay)))
                                .font(.system(size: 11))
                                .padding(4)
                                .background(statusBarManager.isSelectedDate(.previousDay) ? Color.blue.opacity(0.1) : Color.secondary.opacity(0.1))
                                .foregroundColor(statusBarManager.isSelectedDate(.previousDay) ? Color.blue : Color.primary)
                                .cornerRadius(4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            statusBarManager.selectDate(.today)
                        }) {
                            Text(formatDate(statusBarManager.getDate(.today)))
                                .font(.system(size: 11))
                                .padding(4)
                                .background(statusBarManager.isSelectedDate(.today) ? Color.blue.opacity(0.1) : Color.secondary.opacity(0.1))
                                .foregroundColor(statusBarManager.isSelectedDate(.today) ? Color.blue : Color.primary)
                                .cornerRadius(4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            statusBarManager.selectDate(.nextDay)
                        }) {
                            Text(formatDate(statusBarManager.getDate(.nextDay)))
                                .font(.system(size: 11))
                                .padding(4)
                                .background(statusBarManager.isSelectedDate(.nextDay) ? Color.blue.opacity(0.1) : Color.secondary.opacity(0.1))
                                .foregroundColor(statusBarManager.isSelectedDate(.nextDay) ? Color.blue : Color.primary)
                                .cornerRadius(4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            statusBarManager.shiftDateRange(by: 1)
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(.primary)
                                .padding(4)
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(4)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                // 待办事项列表
                VStack(spacing: 6) {
                    Text("待办事项")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    List {
                        ForEach(statusBarManager.getTodoItemsForCurrentDate()) {
                            item in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(alignment: .center, spacing: 6) {
                                    Button(action: {
                                        statusBarManager.toggleTodoItem(item)
                                    }) {
                                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 16))
                                            .foregroundColor(item.isCompleted ? .green : .secondary)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Text(item.text)
                                        .font(.system(size: 13))
                                        .strikethrough(item.isCompleted, color: .secondary)
                                        .foregroundColor(item.isCompleted ? .secondary : .primary)
                                        .onTapGesture {
                                            statusBarManager.selectTodoItem(item)
                                        }
                                    Spacer()
                                    
                                    if !item.isCompleted {
                                        Button(action: {
                                            statusBarManager.postponeTodoItem(item)
                                        }) {
                                            Image(systemName: "calendar.badge.clock")
                                                .font(.system(size: 14))
                                                .foregroundColor(.blue)
                                                .padding(3)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    
                                    Button(action: {
                                        statusBarManager.removeTodoItem(item)
                                    }) {
                                        Image(systemName: "trash")
                                            .font(.system(size: 14))
                                            .foregroundColor(.red.opacity(0.7))
                                            .padding(3)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                
                                // 显示耗时
                                if item.isCompleted, let completedAt = item.completedAt {
                                    let duration = completedAt.timeIntervalSince(item.createdAt)
                                    let hours = Int(duration / 3600)
                                    let minutes = Int((duration.truncatingRemainder(dividingBy: 3600)) / 60)
                                    Text("耗时: \(hours)小时\(minutes)分钟")
                                        .font(.system(size: 10))
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 28)
                                }
                            }
                            .padding(.vertical, 3)
                        }
                    }
                    .listStyle(.plain)
                    .frame(height: 180)
                }
            }
            .padding(16)
            .frame(width: 380)
            .background(Color(NSColor.windowBackgroundColor))
            .onAppear {
                statusBarManager.menuIsOpen = true
            }
        }
        .menuBarExtraStyle(.window)
        
        // 添加一个空的WindowGroup，确保应用程序在设置窗口关闭时不会退出
        WindowGroup {}
    }
}
