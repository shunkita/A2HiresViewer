//
//  HiresViewModel.swift
//  A2HiresViewer
//
//  Created by Shunichi Kitahara on 2025/02/11.
//

import SwiftUI
import AppKit  // NSImage を扱うために必要

class HiresViewModel: ObservableObject {
    @Published var image: NSImage?
    private var hiresImage: AppleIIHiresImage? // 初期化を遅延

    func openFile() {
        let panel = NSOpenPanel()
//        panel.allowedFileTypes = ["bin"]
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let url = panel.url {
            loadHiresImage(from: url)
        }
    }

    func loadHiresImage(from url: URL) {
        guard let hiresImage = AppleIIHiresImage(from: url) else { return }
        self.hiresImage = hiresImage
        self.image = hiresImage.toNSImage()
    }
}
