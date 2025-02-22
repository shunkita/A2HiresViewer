//
//  A2HiresViewerApp.swift
//  A2HiresViewer
//
//  Created by Shunichi Kitahara on 2025/02/11.
//
import SwiftUI

@main
struct A2HiresViewerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize) // **コンテンツサイズに応じたリサイズ制限**
    }
}
