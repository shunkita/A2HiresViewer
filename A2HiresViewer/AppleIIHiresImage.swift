import AppKit
import SwiftUICore

struct XYPosition: Equatable {
    let xBlock: Int
    let y: Int
}

extension NSColor {
    static let brightPurple = NSColor(red: 0.85, green: 0.0, blue: 0.85, alpha: 1.0)
}

struct AppleIIHiresImage {
    let pixels: [[NSColor]]
    
    init?(from url: URL) {
        guard var data = try? Data(contentsOf: url) else {
            return nil
        }
        
        if data.count < 8192 {
            data.append(contentsOf: [UInt8](repeating: 0x00, count: 8192 - data.count))
        }
        
        guard data.count == 8192 else {
            return nil
        }
        
        self.pixels = AppleIIHiresImage.decodeHiresImage(from: data)
    }
    
    init() {
        self.pixels = Array(repeating: Array(repeating: .black, count: 280), count: 192)
    }
    
    static func memoryOffset(forY y: Int) -> Int {
        return (y / 64) * 0x28 + (y % 8) * 0x400 + ((y / 8) & 7) * 0x80
    }
    
    static func decodeHiresImage(from data: Data) -> [[NSColor]] {
        var pixels = Array(repeating: Array(repeating: NSColor.black, count: 280), count: 192)
        
        for y in 0..<192 {
            let addr = memoryOffset(forY: y)
            for xBlock in 0..<40 {
                guard addr + xBlock < data.count else { continue }
                let byte = data[addr + xBlock]
                let decodedColors = decodePixelColors(from: byte, xBlock: xBlock)
                
                for i in 0..<7 {
                    let px = xBlock * 7 + i
                    pixels[y][px] = decodedColors[i]
                }
            }
        }
        
        return applyHiresRules(pixels)
    }
    
    static func decodePixelColors(from byte: UInt8, xBlock: Int) -> [NSColor] {
        let msb = (byte & 0x80) != 0
        let bitPattern = (0..<7).map { (byte >> $0) & 1 == 1 }
        let evenColors: [NSColor] = msb ? [.blue, .orange] : [.brightPurple, .green]
        let oddColors: [NSColor] = msb ? [.orange, .blue] : [.green, .brightPurple]
        let baseColors = xBlock % 2 == 0 ? evenColors : oddColors
        
        var pixels = bitPattern.enumerated().map { index, bit in
            bit ? baseColors[index % 2] : .black
        }
        
        for i in 0..<6 {
            if pixels[i] != .black && pixels[i + 1] != .black {
                pixels[i] = .white
                pixels[i + 1] = .white
            }
        }
        
        return pixels
    }
    
    static func applyHiresRules(_ pixels: [[NSColor]]) -> [[NSColor]] {
        var newPixels = pixels
        
        for y in 0..<192 {
            for x in 1..<279 {
                let left = pixels[y][x - 1]
                let center = pixels[y][x]
                let right = pixels[y][x + 1]
                
                if center == .black {
                    if left != .black && right != .black {
                        newPixels[y][x] = (x % 2 == 0) ? left : right
                    }
                } else {
                    if left == .black && right == .black {
                        newPixels[y][x] = pixels[y][x]
                    } else {
                        newPixels[y][x] = .white
                    }
                }
            }
        }
        
        return newPixels
    }
    
    func getPixel(x: Int, y: Int) -> NSColor {
        guard x >= 0, x < 280, y >= 0, y < 192 else { return .black }
        
        let color = pixels[y][x]
        
        if x > 0 {
            let leftColor = pixels[y][x - 1]
            if color != .black && leftColor != .black && color != leftColor {
                return .white
            }
        }
        
        return color
    }
    
    func toNSImage() -> NSImage {
        let width = 280
        let height = 192
        let imageSize = NSSize(width: width, height: height)
        let image = NSImage(size: imageSize)
        
        image.lockFocus()
        let context = NSGraphicsContext.current!.cgContext
        
        for y in 0..<height {
            for x in 0..<width {
                let color = getPixel(x: x, y: y)
                context.setFillColor(color.cgColor)
                context.fill(CGRect(x: x, y: height - y - 1, width: 1, height: 1))
            }
        }
        
        image.unlockFocus()
        return image
    }
}
