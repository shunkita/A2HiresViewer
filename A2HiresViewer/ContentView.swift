//
//  ContentView.swift
//  A2HiresViewer
//
//  Created by Shunichi Kitahara on 2025/02/11.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HiresViewModel()

    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(nsImage: image)
                    .resizable()
                    .interpolation(.none) // ドットのにじみを防ぐ
                    .aspectRatio(contentMode: .fit) // アスペクト比を維持
                    .frame(width: 560, height: 384) // 2倍サイズ
            } else {
                Text("ファイルを開いてください")
                    .frame(width: 560, height: 384)
                    .border(Color.gray)
            }

            Button("ファイルを開く") {
                viewModel.openFile()
            }
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
