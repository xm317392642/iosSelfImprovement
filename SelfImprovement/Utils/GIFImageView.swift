//
//  GIFImageView.swift
//  SelfImprovement
//
//  Created on 2026/3/5.
//

import UIKit

extension UIImageView {
    
    func loadGIF(from url: URL) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.image = UIImage.gif(data: data)
                }
            } catch {
                print("Error loading GIF: \(error)")
            }
        }
    }
    
    func loadGIF(named: String) {
        guard let url = Bundle.main.url(forResource: named, withExtension: "gif") else {
            print("GIF file not found: \(named)")
            return
        }
        loadGIF(from: url)
    }
}

extension UIImage {
    
    static func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("GIF source creation failed")
            return nil
        }
        
        let count = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        var duration: TimeInterval = 0
        
        for i in 0..<count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                continue
            }
            
            if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
               let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
               let delayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? TimeInterval {
                duration += delayTime
            }
            
            images.append(UIImage(cgImage: cgImage))
        }
        
        if images.isEmpty {
            return nil
        }
        
        let gifImage = UIImage.animatedImage(with: images, duration: duration)
        return gifImage
    }
    
    static func gif(named: String) -> UIImage? {
        guard let url = Bundle.main.url(forResource: named, withExtension: "gif") else {
            print("GIF file not found: \(named)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return gif(data: data)
        } catch {
            print("Error loading GIF: \(error)")
            return nil
        }
    }
}
