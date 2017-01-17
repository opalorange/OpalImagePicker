//
//  UIViewController+OpalImagePicker.swift
//  OpalImagePicker
//
//  Created by Kris Katsanevas on 1/15/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

import UIKit
import Photos

public extension UIViewController {
    
    /// Present Image Picker using closures rather than delegation.
    ///
    /// - Parameters:
    ///   - imagePicker: the `OpalImagePickerController`
    ///   - animated: is presentation animated
    ///   - select: notifies when selection of `[PHAsset]` has been made
    ///   - cancel: notifies when Image Picker has been cancelled by user
    ///   - completion: notifies when the Image Picker finished presenting
    public func presentOpalImagePickerController(_ imagePicker: OpalImagePickerController, animated: Bool, select: @escaping (([PHAsset]) -> Void), cancel: @escaping (() -> Void), completion: (() -> Void)? = nil) {
        let manager = OpalImagePickerManager.sharedInstance
        manager.select = select
        manager.cancel = cancel
        imagePicker.imagePickerDelegate = manager
        present(imagePicker, animated: animated, completion: completion)
    }
}

final class OpalImagePickerManager: NSObject {
    var select: (([PHAsset]) -> Void)?
    var cancel: (() -> Void)?
    
    static let sharedInstance = OpalImagePickerManager()
    fileprivate override init() { }
}

extension OpalImagePickerManager: OpalImagePickerControllerDelegate {
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        select?(assets)
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        cancel?()
    }
}
