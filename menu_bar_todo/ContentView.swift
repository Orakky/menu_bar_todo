//
//  ContentView.swift
//  menu_bar_todo
//
//  Created by 啊！是松松松 on 2026/3/13.
//

import SwiftUI

struct ContentView: View {
    @Binding var statusText: String
    @State private var inputText: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Enter text to display in menu bar:")
                .font(.headline)
            
            HStack {
                TextField("Type here...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(8)
                    .onSubmit {
                        updateStatusText()
                    }
                
                Button(action: updateStatusText) {
                    Image(systemName: "checkmark")
                        .padding(8)
                }
                .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            
            if !statusText.isEmpty {
                Text("Current menu bar text: \(statusText)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(20)
        .frame(width: 300)
    }

    private func updateStatusText() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        statusText = inputText.trimmingCharacters(in: .whitespaces)
        inputText = ""
    }
}