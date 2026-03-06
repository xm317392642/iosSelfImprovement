//
//  MediaPickerManager.swift
//  SelfImprovement
//
//  Created on 2026/3/5.
//  多媒体选择管理器，支持图片和视频选择
//

import UIKit
import PhotosUI
import Photos

protocol MediaPickerDelegate: AnyObject {
    func didPickImages(_ images: [UIImage])
    func didPickVideo(_ url: URL)
    func didCancel()
}

class MediaPickerManager: NSObject {
    
    weak var delegate: MediaPickerDelegate?
    private weak var presentingViewController: UIViewController?
    
    func pickImages(from viewController: UIViewController, maxCount: Int = 9) {
        presentingViewController = viewController
        
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = maxCount
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController.present(picker, animated: true)
    }
    
    func pickVideo(from viewController: UIViewController) {
        presentingViewController = viewController
        
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        configuration.filter = .videos
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController.present(picker, animated: true)
    }
    
    func pickMedia(from viewController: UIViewController, maxCount: Int = 9) {
        presentingViewController = viewController
        
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = maxCount
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController.present(picker, animated: true)
    }
    
    func capturePhoto(from viewController: UIViewController) {
        presentingViewController = viewController
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = false
        viewController.present(picker, animated: true)
    }
    
    func captureVideo(from viewController: UIViewController) {
        presentingViewController = viewController
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = ["public.movie"]
        picker.delegate = self
        picker.videoQuality = .typeHigh
        viewController.present(picker, animated: true)
    }
    
    func showMediaOptions(from viewController: UIViewController, allowVideo: Bool = true) {
        let actionSheet = UIAlertController(title: "选择媒体", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "拍照", style: .default) { [weak self] _ in
            self?.capturePhoto(from: viewController)
        })
        
        if allowVideo {
            actionSheet.addAction(UIAlertAction(title: "录制视频", style: .default) { [weak self] _ in
                self?.captureVideo(from: viewController)
            })
        }
        
        actionSheet.addAction(UIAlertAction(title: "从相册选择图片", style: .default) { [weak self] _ in
            self?.pickImages(from: viewController)
        })
        
        if allowVideo {
            actionSheet.addAction(UIAlertAction(title: "从相册选择视频", style: .default) { [weak self] _ in
                self?.pickVideo(from: viewController)
            })
        }
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        viewController.present(actionSheet, animated: true)
    }
    
    private func processImage(_ result: PHPickerResult, completion: @escaping (UIImage?) -> Void) {
        result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            if let image = object as? UIImage {
                let resizedImage = self.resizeImage(image)
                completion(resizedImage)
            } else {
                completion(nil)
            }
        }
    }
    
    private func processVideo(_ result: PHPickerResult, completion: @escaping (URL?) -> Void) {
        result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
            if let url = url {
                let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let destinationURL = documentsPath.appendingPathComponent(UUID().uuidString + ".mp4")
                
                do {
                    if FileManager.default.fileExists(atPath: destinationURL.path) {
                        try FileManager.default.removeItem(at: destinationURL)
                    }
                    try FileManager.default.copyItem(at: url, to: destinationURL)
                    completion(destinationURL)
                } catch {
                    print("Error copying video: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    private func resizeImage(_ image: UIImage) -> UIImage {
        let maxSize = AppConfig.MAX_PHOTO_DIMENSION
        
        if image.size.width <= maxSize && image.size.height <= maxSize {
            return image
        }
        
        let widthRatio = maxSize / image.size.width
        let heightRatio = maxSize / image.size.height
        let ratio = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage ?? image
    }
}

extension MediaPickerManager: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if results.isEmpty {
            delegate?.didCancel()
            return
        }
        
        var images: [UIImage] = []
        var videoURL: URL?
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            
            result.itemProvider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { [weak self] item, error in
                if let image = item as? UIImage {
                    let resizedImage = self?.resizeImage(image) ?? image
                    images.append(resizedImage)
                }
                group.leave()
            }
            
            result.itemProvider.loadItem(forTypeIdentifier: UTType.movie.identifier, options: nil) { item, error in
                if let url = item as? URL {
                    videoURL = url
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            if let videoURL = videoURL {
                self?.delegate?.didPickVideo(videoURL)
            } else if !images.isEmpty {
                self?.delegate?.didPickImages(images)
            }
        }
    }
}

extension MediaPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            let resizedImage = resizeImage(image)
            delegate?.didPickImages([resizedImage])
        } else if let videoURL = info[.mediaURL] as? URL {
            delegate?.didPickVideo(videoURL)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        delegate?.didCancel()
    }
}
