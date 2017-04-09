//
//  OpalImagePickerController.swift
//  OpalImagePicker
//
//  Created by Kris Katsanevas on 1/15/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

import UIKit
import Photos

/// Image Picker Controller Delegate. Notifies when images are selected or image picker is cancelled.
@objc public protocol OpalImagePickerControllerDelegate: class {
    
    /// Image Picker did finish picking images. Provides an array of `UIImage` selected.
    ///
    /// - Parameters:
    ///   - picker: the `OpalImagePickerController`
    ///   - images: the array of `UIImage`
    @objc optional func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage])
    
    /// Image Picker did finish picking images. Provides an array of `PHAsset` selected.
    ///
    /// - Parameters:
    ///   - picker: the `OpalImagePickerController`
    ///   - assets: the array of `PHAsset`
    @objc optional func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset])
    
    /// Image Picker did cancel.
    ///
    /// - Parameter picker: the `OpalImagePickerController`
    @objc optional func imagePickerDidCancel(_ picker: OpalImagePickerController)
}

/// Image Picker Controller. Displays images from the Photo Library. Must check Photo Library permissions before attempting to display this controller.
open class OpalImagePickerController: UINavigationController {
    
    /// Image Picker Delegate. Notifies when images are selected or image picker is cancelled.
    open weak var imagePickerDelegate: OpalImagePickerControllerDelegate? {
        didSet {
            let rootVC = viewControllers.first as? OpalImagePickerRootViewController
            rootVC?.delegate = imagePickerDelegate
        }
    }
    
    /// Custom Tint Color for overlay of selected images.
    open var selectionTintColor: UIColor? {
        didSet {
            let rootVC = viewControllers.first as? OpalImagePickerRootViewController
            rootVC?.selectionTintColor = selectionTintColor
        }
    }
    
    /// Custom Tint Color for selection image (checkmark).
    open var selectionImageTintColor: UIColor? {
        didSet {
            let rootVC = viewControllers.first as? OpalImagePickerRootViewController
            rootVC?.selectionImageTintColor = selectionImageTintColor
        }
    }
    
    /// Custom selection image (checkmark).
    open var selectionImage: UIImage? {
        didSet {
            let rootVC = viewControllers.first as? OpalImagePickerRootViewController
            rootVC?.selectionImage = selectionImage
        }
    }
    
    /// Maximum photo selections allowed in picker (zero or fewer means unlimited).
    open var maximumSelectionsAllowed: Int = -1 {
        didSet {
            let rootVC = viewControllers.first as? OpalImagePickerRootViewController
            rootVC?.maximumSelectionsAllowed = maximumSelectionsAllowed
        }
    }
    
    /// Allowed Media Types that can be fetched. See `PHAssetMediaType`
    open var allowedMediaTypes: Set<PHAssetMediaType>? {
        didSet {
            let rootVC = viewControllers.first as? OpalImagePickerRootViewController
            rootVC?.allowedMediaTypes = allowedMediaTypes
        }
    }
    
    /// Allowed MediaSubtype that can be fetched. Can be applied as `OptionSet`. See `PHAssetMediaSubtype`
    open var allowedMediaSubtypes: PHAssetMediaSubtype? {
        didSet {
            let rootVC = viewControllers.first as? OpalImagePickerRootViewController
            rootVC?.allowedMediaSubtypes = allowedMediaSubtypes
        }
    }
    
    /// Status Bar Preference (defaults to `default`)
    open var statusBarPreference = UIStatusBarStyle.default
    
    /// Initializer
    public required init() {
        super.init(rootViewController: OpalImagePickerRootViewController())
    }
    
    /// Initializer (Do not use this controller in Interface Builder)
    ///
    /// - Parameters:
    ///   - nibNameOrNil: the nib name
    ///   - nibBundleOrNil: the nib `Bundle`
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// Initializer (Do not use this controller in Interface Builder)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Cannot init \(String(describing: OpalImagePickerController.self)) from Interface Builder")
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarPreference
    }
}
