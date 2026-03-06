//
//  AvatarHelper.swift
//  SelfImprovement
//
//  Created on 2026/3/5.
//  头像处理工具，根据健康值动态调整美颜程度
//

import UIKit
import GPUPixel

class AvatarHelper {
    static let shared = AvatarHelper()
    
    private init() {}
    
    /// 根据健康值处理头像
    /// - Parameters:
    ///   - image: 原始头像
    ///   - healthScore: 健康值
    /// - Returns: 处理后的头像
    func processAvatar(_ image: UIImage, healthScore: Double) -> UIImage {
        // 根据健康值计算美颜程度
        let beautyLevel = calculateBeautyLevel(healthScore)
        
        // 创建滤镜链
        let filterChain = GPUFilterChain()
        
        // 添加基础滤镜
        let whiteBalance = GPUWhiteBalanceFilter()
        whiteBalance.temperature = 5500.0 + Double(beautyLevel * 100)
        whiteBalance.tint = 0.0
        filterChain.addFilter(whiteBalance)
        
        // 磨皮滤镜
        let bilateral = GPUBilateralFilter()
        bilateral.distanceNormalizationFactor = 8.0 - Double(beautyLevel * 5)
        filterChain.addFilter(bilateral)
        
        // 锐化滤镜
        let sharpen = GPUSharpenFilter()
        sharpen.sharpness = Float(0.1 + beautyLevel * 0.3)
        filterChain.addFilter(sharpen)
        
        // 处理图片
        if let processedImage = filterChain.process(image) {
            return processedImage
        }
        
        return image
    }
    
    /// 根据健康值计算美颜程度
    /// - Parameter healthScore: 健康值
    /// - Returns: 美颜程度 (0.0-1.0)
    private func calculateBeautyLevel(_ healthScore: Double) -> Float {
        // 健康值越高，美颜程度越高
        let normalizedScore = max(0, min(100, healthScore)) / 100.0
        return Float(normalizedScore)
    }
    
    /// 生成默认头像
    /// - Returns: 默认头像
    func generateDefaultAvatar() -> UIImage {
        let size = CGSize(width: 200, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            // 绘制背景
            UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0).setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // 绘制用户图标
            let image = UIImage(systemName: "person.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            let imageRect = CGRect(x: 50, y: 50, width: 100, height: 100)
            image?.draw(in: imageRect)
        }
    }
    
    /// 保存头像
    /// - Parameters:
    ///   - image: 头像图片
    ///   - completion: 完成回调
    func saveAvatar(_ image: UIImage, completion: @escaping (Bool, URL?) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            completion(false, nil)
            return
        }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let avatarURL = documentsDirectory?.appendingPathComponent("avatar.jpg")
        
        do {
            try data.write(to: avatarURL!)
            UserDefaults.standard.set(avatarURL?.path, forKey: "avatarPath")
            completion(true, avatarURL)
        } catch {
            print("Error saving avatar: \(error)")
            completion(false, nil)
        }
    }
    
    /// 加载头像
    /// - Returns: 头像图片
    func loadAvatar() -> UIImage? {
        if let path = UserDefaults.standard.string(forKey: "avatarPath"),
           let image = UIImage(contentsOfFile: path) {
            return image
        }
        return nil
    }
}