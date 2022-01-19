//
//  main.swift
//  autocrop
//
//  Created by Alex Dong on 19/01/22.
//

import Foundation
import AppKit
import Vision

let MARGIN = 0.03  // 5%

func trim(image: NSImage, rect: CGRect) -> NSImage {
    let result = NSImage(size: rect.size)
    result.lockFocus()
    
    let destRect = CGRect(origin: .zero, size: result.size)
    image.draw(in: destRect, from: rect, operation: .copy, fraction: 1.0)
    
    result.unlockFocus()
    return result
}

public extension NSImage {
    func writePNG(toURL url: URL) {
        guard let data = tiffRepresentation,
              let rep = NSBitmapImageRep(data: data),
              let imgData = rep.representation(using: .png, properties: [.compressionFactor : NSNumber(floatLiteral: 1.0)]) else {
                  
                  Swift.print("\(self) Error Function '\(#function)' Line: \(#line) No tiff rep found for image writing to \(url)")
                  return
              }
        
        do {
            try imgData.write(to: url)
        }catch let error {
            Swift.print("\(self) Error Function '\(#function)' Line: \(#line) \(error.localizedDescription)")
        }
    }
}

func contentAnalysis(url: URL) throws {
    // Run the Face Capture and Classification on the "focused" image.
    let image = NSImage(contentsOfFile: url.path)!
    let handler = VNImageRequestHandler(url: url)
    let faceDetection = VNDetectFaceCaptureQualityRequest()
    try handler.perform([faceDetection])
    
    for observation in faceDetection.results! {
        let margin = max(image.size.width, image.size.height) * MARGIN
        let boundingBox = observation.boundingBox
        let size = max(boundingBox.size.width, boundingBox.size.height) * max(image.size.width, image.size.height)
        let cropRect = CGRect(
            x: boundingBox.origin.x * image.size.width - margin/2,
            y: boundingBox.origin.y * image.size.height - margin/2,
            width: size + margin,
            height: size + margin)
        
        let cropped = trim(image: NSImage(contentsOfFile: url.path)!, rect: cropRect)
        let outputFilename = outputPath + UUID().uuidString + ".jpg"
        cropped.writePNG(toURL: URL(fileURLWithPath: outputFilename))
    }
}

let args = CommandLine.arguments
let inputFilePath = args[1]
let outputPath = args[2]
try contentAnalysis(url: URL(fileURLWithPath: inputFilePath))
