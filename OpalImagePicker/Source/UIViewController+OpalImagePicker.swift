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
    func presentOpalImagePickerController(_ imagePicker: OpalImagePickerController, animated: Bool, select: @escaping (([PHAsset]) -> Void), cancel: @escaping (() -> Void), completion: (() -> Void)? = nil) {
        let manager = OpalImagePickerManager.shared
        manager.selectAssets = select
        manager.cancel = cancel
        imagePicker.imagePickerDelegate = manager
        present(imagePicker, animated: animated, completion: completion)
    }
    
    /// Present Image Picker with External Images using closures rather than delegation.
    ///
    /// - Parameters:
    ///   - imagePicker: the `OpalImagePickerController`
    ///   - animated: is presentation animated
    ///   - maximumSelectionsAllowed: the maximum number of image selections allowed for the user. Defaults to 10. This is advised to limit the amount of memory to store all the images.
    ///   - numberOfExternalItems: the number of external items
    ///   - externalItemsTitle: the localized title for display in the `UISegmentedControl`
    ///   - externalURLForIndex: the `URL` for an external item at the given index.
    ///   - selectImages: notifies that image selections have completed with an array of `UIImage`
    ///   - selectAssets: notifies that image selections have completed with an array of `PHAsset`
    ///   - selectExternalURLs: notifies that image selections have completed with an array of `URL`
    ///   - cancel: notifies when Image Picker has been cancelled by user
    ///   - completion: notifies when the Image Picker finished presenting
    func presentOpalImagePickerController(_ imagePicker: OpalImagePickerController, animated: Bool, maximumSelectionsAllowed: Int = 10, numberOfExternalItems: Int, externalItemsTitle: String, externalURLForIndex: @escaping (Int) -> URL?, selectImages: (([UIImage]) -> Void)? = nil, selectAssets: (([PHAsset]) -> Void)? = nil, selectExternalURLs: (([URL]) -> Void)? = nil, cancel: @escaping () -> Void, completion: (() -> Void)? = nil) {
        let manager = OpalImagePickerWithExternalItemsManager.sharedWithExternalItems
        
        if (selectImages != nil) {
            print("The `selectImages` parameter will be removed in future versions. Please switch to using `selectAssets`, and download `UIImage` using the `PHAsset` APIs.")
        }
        
        manager.selectImages = selectImages
        manager.selectAssets = selectAssets
        manager.selectURLs = selectExternalURLs
        manager.cancel = cancel
        manager.numberOfExternalItems = numberOfExternalItems
        manager.externalItemsTitle = externalItemsTitle
        manager.externalURLForIndex = externalURLForIndex
        imagePicker.imagePickerDelegate = manager
        imagePicker.maximumSelectionsAllowed = maximumSelectionsAllowed
        present(imagePicker, animated: animated, completion: completion)
    }
}

class OpalImagePickerWithExternalItemsManager: OpalImagePickerManager {
    var selectImages: (([UIImage]) -> Void)?
    var selectURLs: (([URL]) -> Void)?
    var externalURLForIndex: ((Int) -> URL?)?
    var numberOfExternalItems = 0
    var externalItemsTitle = NSLocalizedString("External", comment: "External (Segmented Control Title)")
    
    static let sharedWithExternalItems = OpalImagePickerWithExternalItemsManager()
    
    override init() { }
    
    func imagePickerNumberOfExternalItems(_ picker: OpalImagePickerController) -> Int {
        return numberOfExternalItems
    }
    
    func imagePickerTitleForExternalItems(_ picker: OpalImagePickerController) -> String {
        return externalItemsTitle
    }
    
    func imagePicker(_ picker: OpalImagePickerController, imageURLforExternalItemAtIndex index: Int) -> URL? {
        return externalURLForIndex?(index)
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingExternalURLs urls: [URL]) {
        selectURLs?(urls)
    }
    
    func imagePickerDidFinishPickingImages(_ picker: OpalImagePickerController, images: [UIImage]) {
        selectImages?(images)
    }
}

class OpalImagePickerManager: NSObject {
    var selectAssets: (([PHAsset]) -> Void)?
    var cancel: (() -> Void)?
    
    static var shared = OpalImagePickerManager()
    override init() { }
}

extension OpalImagePickerManager: OpalImagePickerControllerDelegate {
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        selectAssets?(assets)
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        cancel?()
    }
}
