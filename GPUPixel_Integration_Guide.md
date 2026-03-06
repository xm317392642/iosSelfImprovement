# GPUPixel 集成指南

## 概述
GPUPixel 是一个高性能、跨平台的图像和视频滤镜库，基于 C++11 和 OpenGL/ES 构建，提供实时美颜滤镜效果。

## 集成步骤

### 步骤 1: 添加 CocoaPods 依赖

在项目根目录创建或更新 `Podfile` 文件：

```ruby
# Podfile
target 'SelfImprovement' do
  use_frameworks!
  
  # GPUPixel 依赖
  pod 'GPUPixel', :git => 'https://github.com/pixpark/gpupixel.git'
  
  # 其他依赖
  # pod '其他库'
end
```

### 步骤 2: 安装依赖

在终端中运行：

```bash
cd d:\project\iosSelfImprovement
pod install
```

### 步骤 3: 更新 CameraViewController

修改 `CameraViewController.swift` 文件，集成 GPUPixel：

```swift
//
//  CameraViewController.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import UIKit
import AVFoundation
import GPUPixel

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
    
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    // GPUPixel 相关
    private var filterChain: GPUFilterChain?
    private var renderView: GLView?
    
    private let captureButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    private let beautyButton = UIButton(type: .system)
    
    private var isBeautyEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCamera()
        setupGPUPixel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // GPUPixel 渲染视图
        renderView = GLView(frame: view.bounds)
        if let renderView = renderView {
            view.addSubview(renderView)
        }
        
        captureButton.setImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        captureButton.tintColor = .white
        captureButton.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        view.addSubview(captureButton)
        
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        beautyButton.setImage(UIImage(systemName: "sparkles"), for: .normal)
        beautyButton.tintColor = .white
        beautyButton.addTarget(self, action: #selector(beautyButtonTapped), for: .touchUpInside)
        view.addSubview(beautyButton)
        
        renderView?.translatesAutoresizingMaskIntoConstraints = false
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        beautyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            renderView!.topAnchor.constraint(equalTo: view.topAnchor),
            renderView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            renderView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            renderView!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            captureButton.widthAnchor.constraint(equalToConstant: 80),
            captureButton.heightAnchor.constraint(equalToConstant: 80),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            beautyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            beautyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            beautyButton.widthAnchor.constraint(equalToConstant: 44),
            beautyButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("No camera available")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
        } catch {
            print("Error setting up camera: \(error)")
        }
    }
    
    private func setupGPUPixel() {
        // 创建滤镜链
        filterChain = GPUFilterChain()
        
        // 设置输出视图
        if let renderView = renderView, let filterChain = filterChain {
            filterChain.outputFrameBuffer = GLViewFrameBuffer(view: renderView)
        }
        
        // 启用美颜滤镜
        enableBeautyFilters()
    }
    
    private func enableBeautyFilters() {
        guard let filterChain = filterChain else { return }
        
        // 清除现有滤镜
        filterChain.clearFilters()
        
        // 添加美颜滤镜
        if isBeautyEnabled {
            // 美白滤镜
            let whiteBalance = GPUWhiteBalanceFilter()
            whiteBalance.temperature = 5500.0
            whiteBalance.tint = 0.0
            filterChain.addFilter(whiteBalance)
            
            // 磨皮滤镜
            let bilateral = GPUBilateralFilter()
            bilateral.distanceNormalizationFactor = 8.0
            filterChain.addFilter(bilateral)
            
            // 瘦脸滤镜
            let faceReshape = GPUFaceReshapeFilter()
            faceReshape.faceThinning = 0.3
            faceReshape.faceLifting = 0.2
            filterChain.addFilter(faceReshape)
            
            // 大眼滤镜
            let eyeEnlarging = GPUEyeEnlargingFilter()
            eyeEnlarging.eyeEnlarging = 0.2
            filterChain.addFilter(eyeEnlarging)
        }
    }
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let filterChain = filterChain else { return }
        
        // 将相机帧传递给 GPUPixel 处理
        filterChain.process(pixelBuffer)
    }
    
    @objc private func captureButtonTapped() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc private func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func beautyButtonTapped() {
        isBeautyEnabled.toggle()
        enableBeautyFilters()
        
        // 更新按钮状态
        let imageName = isBeautyEnabled ? "sparkles.fill" : "sparkles"
        beautyButton.setImage(UIImage(systemName: imageName), for: .normal)
        beautyButton.tintColor = isBeautyEnabled ? .yellow : .white
    }
    
    // MARK: - AVCapturePhotoCaptureDelegate
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("No photo data")
            return
        }
        
        if let image = UIImage(data: imageData) {
            // 保存照片到相册
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            // 显示成功提示
            let alert = UIAlertController(title: "成功", message: "照片已保存", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default))
            present(alert, animated: true)
        }
    }
}
```

### 步骤 4: 创建 AvatarHelper 类

创建 `AvatarHelper.swift` 文件，实现头像处理功能：

```swift
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
```

### 步骤 5: 配置 Info.plist

在 `Info.plist` 中添加相机权限：

```xml
<key>NSCameraUsageDescription</key>
<string>需要使用相机来拍摄照片</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>需要访问相册来选择图片</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>需要保存照片到相册</string>
```

### 步骤 6: 在 ProfileViewController 中使用 AvatarHelper

修改 `ProfileViewController.swift` 以使用 AvatarHelper：

```swift
// 在 didPickImages 方法中添加
func didPickImages(_ images: [UIImage]) {
    if let image = images.first {
        // 使用 AvatarHelper 处理头像
        let healthScore = HealthScoreRepository.shared.getTodayHealthScore()
        let processedImage = AvatarHelper.shared.processAvatar(image, healthScore: healthScore)
        
        avatarImageView.image = processedImage
        
        // 保存头像
        AvatarHelper.shared.saveAvatar(processedImage) { success, url in
            if success {
                EventCenter.shared.post(AppConfig.EVENT_AVATAR_UPDATED, value: true)
            }
        }
    }
}
```

## 实现效果

1. **实时美颜预览** - 相机预览时实时应用美颜效果
2. **美颜开关** - 可通过按钮切换美颜效果
3. **健康值关联** - 头像美颜程度随健康值动态调整
4. **多种美颜效果** - 包括美白、磨皮、瘦脸、大眼

## 注意事项

1. **性能优化** - GPUPixel 使用 GPU 加速，确保在低配置设备上也能流畅运行
2. **内存管理** - 及时释放不再使用的滤镜资源
3. **权限处理** - 确保正确处理相机权限请求
4. **错误处理** - 添加适当的错误处理机制

## 扩展功能

你可以根据需要扩展以下功能：

1. **滤镜选择** - 添加更多滤镜效果供用户选择
2. **美颜参数调节** - 允许用户自定义美颜程度
3. **视频录制** - 支持录制带美颜效果的视频
4. **实时人脸检测** - 优化美颜效果的应用区域

## 故障排除

如果遇到以下问题：

1. **编译错误** - 确保 CocoaPods 安装正确，检查依赖版本
2. **相机黑屏** - 检查相机权限是否正确配置
3. **美颜效果不明显** - 调整滤镜参数，增加美颜强度
4. **性能问题** - 减少同时使用的滤镜数量，优化渲染设置

## 参考资源

- [GPUPixel GitHub 仓库](https://github.com/pixpark/gpupixel)
- [GPUPixel 文档](https://github.com/pixpark/gpupixel/tree/master/doc)
- [iOS Camera Programming Guide](https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture)
