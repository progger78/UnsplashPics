//
//  ImageSaver.swift
//  UnsplashPics
//
//  Created by 1 on 19.02.2025.
//

import UIKit
import Photos

class ImageSaver: NSObject {
    
    static let shared = ImageSaver()
    
    private override init() {}
    
    func saveImage(_ photo: DetailPhoto) async throws {
        let status = await checkPermission()
        
        switch status {
        case .authorized, .limited:
            try await writeImageToGallery(photo: photo)
        case .denied:
            throw ImageSaveError.permissionDenied
        case .restricted:
            throw ImageSaveError.restricted
        case .notDetermined:
            throw ImageSaveError.unknown
        @unknown default:
            throw ImageSaveError.unknown
        }
    }
    
    private func checkPermission() async -> PHAuthorizationStatus {
        let currentStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        
        if currentStatus == .notDetermined {
            await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        }
        
        return currentStatus
    }
    
    private func writeImageToGallery(photo: DetailPhoto) async throws {
        guard let image = await ImageLoader.shared.fetchImage(for: photo.urls.full) else {
            throw ImageSaveError.failedToLoadImage
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error {
            print("Ошибка сохранения: \(error.localizedDescription)")
        } else {
            print("Изображение сохранено в галерею!")
        }
    }
    
}
