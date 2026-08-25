import Foundation
import AVFoundation
import ImageIO
import UniformTypeIdentifiers
import CoreGraphics

let videoURL = URL(fileURLWithPath: "/Users/ogulcansivri/Desktop/Ekran Kaydı 2026-08-25 18.03.18.mov")
let outputGIFURL = URL(fileURLWithPath: "/Users/ogulcansivri/.gemini/antigravity/scratch/DropShelf/assets/demo.gif")

let asset = AVURLAsset(url: videoURL)
let duration = CMTimeGetSeconds(asset.duration)

print("Video duration: \(duration)s")

let generator = AVAssetImageGenerator(asset: asset)
generator.appliesPreferredTrackTransform = true
generator.maximumSize = CGSize(width: 800, height: 600)
generator.requestedTimeToleranceBefore = .zero
generator.requestedTimeToleranceAfter = .zero

// Sample at 12 fps for super smooth animation while keeping file size tight
let fps: Double = 12.0
let totalFrames = Int(duration * fps)
let frameDuration = 1.0 / fps

var times: [NSValue] = []
for i in 0..<totalFrames {
    let time = CMTime(seconds: Double(i) * frameDuration, preferredTimescale: 600)
    times.append(NSValue(time: time))
}

let fileProperties: [CFString: Any] = [
    kCGImagePropertyGIFDictionary: [
        kCGImagePropertyGIFLoopCount: 0 // Infinite loop
    ]
]

let frameProperties: [CFString: Any] = [
    kCGImagePropertyGIFDictionary: [
        kCGImagePropertyGIFDelayTime: frameDuration,
        kCGImagePropertyGIFUnclampedDelayTime: frameDuration
    ]
]

guard let destination = CGImageDestinationCreateWithURL(outputGIFURL as CFURL, UTType.gif.identifier as CFString, totalFrames, nil) else {
    print("Failed to create CGImageDestination")
    exit(1)
}

CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)

print("Generating \(totalFrames) frames...")

var count = 0
for timeValue in times {
    let time = timeValue.timeValue
    do {
        let imageRef = try generator.copyCGImage(at: time, actualTime: nil)
        CGImageDestinationAddImage(destination, imageRef, frameProperties as CFDictionary)
        count += 1
        if count % 20 == 0 || count == totalFrames {
            print("Processed \(count)/\(totalFrames) frames...")
        }
    } catch {
        print("Error extracting frame at \(time): \(error)")
    }
}

if CGImageDestinationFinalize(destination) {
    print("✨ High Quality GIF successfully created at: \(outputGIFURL.path)")
} else {
    print("Failed to finalize GIF")
}
