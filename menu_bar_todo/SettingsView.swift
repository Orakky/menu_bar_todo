//
//  SettingsView.swift
//  menu_bar_todo
//
//  Created by 啊！是松松松 on 2026/3/17.
//

import SwiftUI
import AppKit

struct SettingsView: View {
    @ObservedObject var statusBarManager: StatusBarManager
    @State private var startAtLogin: Bool = false
    @State private var selectedTab: String = "基础"
    
    var body: some View {
        VStack(spacing: 0) {
            // 标签栏
            HStack(spacing: 12) {
                Spacer()
                TabButton(title: "基础", isSelected: selectedTab == "基础", action: { selectedTab = "基础" })
                TabButton(title: "更新", isSelected: selectedTab == "更新", action: { selectedTab = "更新" })
                TabButton(title: "关于", isSelected: selectedTab == "关于", action: { selectedTab = "关于" })
                Spacer()
            }
            .padding(.vertical, 10)
            .background(Color(NSColor.windowBackgroundColor))
            .border(bottom: 1, color: Color.secondary.opacity(0.2))
            
            // 内容区域
            VStack(alignment: .center, spacing: 16) {
                if selectedTab == "基础" {
                    VStack(alignment: .center, spacing: 8) {
                        HStack(alignment: .center, spacing: 10) {
                            Toggle(isOn: $startAtLogin) {
                                Text("在开机时启动")
                                    .font(.system(size: 13))
                                    .foregroundColor(.primary)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                            .onChange(of: startAtLogin) {
                                statusBarManager.setStartAtLogin(startAtLogin)
                            }
                        }
                    }
                } else if selectedTab == "更新" {
                    VStack(alignment: .center, spacing: 8) {
                        Button(action: {
                            // 检查更新的逻辑 - 打开GitHub链接
                            if let url = URL(string: "https://github.com/Orakky/dustin") {
                                NSWorkspace.shared.open(url)
                            }
                        }) {
                            HStack(spacing: 6) {
                                Text("检查更新")
                                    .font(.system(size: 13))
                                    .fontWeight(.medium)
                                    .foregroundColor(.blue)
                                Image(systemName: "arrow.down.circle")
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                } else if selectedTab == "关于" {
                    VStack(alignment: .center, spacing: 8) {
                        HStack(alignment: .center, spacing: 10) {
                            Text("MBT")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            Text(">^<")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        HStack(spacing: 4) {
                            Text("author: ")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                            Button(action: {
                                if let url = URL(string: "https://github.com/Orakky") {
                                    NSWorkspace.shared.open(url)
                                }
                            }) {
                                Text("orakky")
                                    .font(.system(size: 13))
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .background(Color(NSColor.windowBackgroundColor))
        }
        .frame(width: 360, height: 180) // 固定窗口大小
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            // 在视图出现时更新开机启动状态
            startAtLogin = statusBarManager.isStartAtLogin()
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action)
        {
            VStack(spacing: 3) {
                if title == "基础" {
                    Image(systemName: "gear")
                        .font(.system(size: 16))
                        .foregroundColor(isSelected ? .blue : .secondary)
                } else if title == "更新" {
                    Image(systemName: "arrow.down.circle")
                        .font(.system(size: 16))
                        .foregroundColor(isSelected ? .blue : .secondary)
                } else if title == "关于" {
                    Image(systemName: "info.circle")
                        .font(.system(size: 16))
                        .foregroundColor(isSelected ? .blue : .secondary)
                }
                Text(title)
                    .font(.system(size: 10))
                    .foregroundColor(isSelected ? .blue : .secondary)
            }
            .padding(10)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// 扩展View，添加底部边框
extension View {
    func border(bottom: CGFloat, color: Color) -> some View {
        self
            .overlay(
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(color)
                        .frame(height: bottom)
                }
                .padding(.bottom, -bottom)
            )
    }
}
