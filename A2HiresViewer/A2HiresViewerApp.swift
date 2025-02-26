//
//  A2HiresViewerApp.swift
//  A2HiresViewer
//
//  Created by Shunichi Kitahara on 2025/02/11.
//
import SwiftUI

@main
struct A2HiresViewerApp: App {
    @StateObject private var viewModel = HiresViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
        .windowResizability(.contentSize) // **コンテンツサイズに応じたリサイズ制限**
        .commands { CommandGroup(replacing: .newItem) {
            Button("Open...") {
                viewModel.openFile() 
            }
            .keyboardShortcut("O", modifiers: .command)
            }
        }
    }
}
