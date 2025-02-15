//
//  HiresViewModel.swift
//  A2HiresViewer
//
//  Created by Shunichi Kitahara on 2025/02/11.
//

import SwiftUI
import AppKit  // NSImage を扱うために必要

class HiresViewModel: ObservableObject {
    @Published var hiresImage: AppleIIHiresImage?
    
    var image: NSImage? {
        guard let hiresImage = hiresImage else { return nil }
        return hiresImage.toNSImage() // AppleIIHiresImage に NSImage 変換処理を追加
    }

    func openFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.data]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        if panel.runModal() == .OK, let url = panel.url {
            if let image = AppleIIHiresImage(from: url) {
                DispatchQueue.main.async {
                    self.hiresImage = image
                }
            }
        }
    }
}

