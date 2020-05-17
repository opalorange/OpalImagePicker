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
    
    /// Image Picker Number of External items. Optional use to provide items from external
    /// sources e.g. (Facebook, Twitter, or Instagram).
    ///
    /// - Parameter picker: the `OpalImagePickerController`
    /// - Returns: an `Int` describing the number of available external image `URL`
    @objc optional func imagePickerNumberOfExternalItems(_ picker: OpalImagePickerController) -> Int
    
    /// Image Picker returns the `URL` for an image at an `Int` index. Optional use to provide items from external
    /// sources e.g. (Facebook, Twitter, or Instagram).
    ///
    /// - Parameters:
    ///   - picker: the `OpalImagePickerController`
    ///   - index: the `Int` index for the image
    /// - Returns: the `URL`
    @objc optional func imagePicker(_ picker: OpalImagePickerController, imageURLforExternalItemAtIndex index: Int) -> URL?
    
    /// Image Picker external title. This will appear in the `UISegmentedControl`. Make sure to provide a Localized String.
    ///
    /// - Parameter picker: the `OpalImagePickerController`
    /// - Returns: the `String`. This should be a Localized String.
    @objc optional func imagePickerTitleForExternalItems(_ picker: OpalImagePickerController) -> String
    
    /// Image Picker did finish picking external images. Provides an array of `URL` selected.
    ///
    /// - Parameters:
    ///   - picker: the `OpalImagePickerController`
    ///   - urls: the array of `URL`
    @objc optional func imagePicker(_ picker: OpalImagePickerController, didFinishPickingExternalURLs urls: [URL])
}

/// Image Picker Controller. Displays images from the Photo Library. Must check Photo Library permissions before attempting to display this controller.
open class OpalImagePickerController: UINavigationController {
    
    /// Image Picker Delegate. Notifies when images are selected or image picker is cancelled.
    @objc open weak var imagePickerDelegate: OpalImagePickerControllerDelegate? {
        didSet {
            let rootVC = viewControllers.first as? OpalImagePickerRootViewController
            rootVC?.delegate = imagePickerDelegate
        }
    }

    /// Configuration to change Localized Strings
    @objc open var configuration: OpalImagePickerConfiguration? {
        didSet {
            let rootVC = viewControllers.first as? OpalImagePickerRootViewController
            rootVC?.configuration = configuration
        }
    }
    
    /// Custom Tint Color for overlay of selected images.
    @objc open var selectionTintColor: UIColor? {
        didSet {
            let rootVC = viewControllers.first as? OpalImagePickerRootViewController
            rootVC?.selectionTintColor = selectionTintColor
        }
    }
    
    /// Custom Tint Color for selection image (checkmark).
    @objc open var selectionImageTintColor: UIColor? {
        didSet {
            let rootVC = viewControllers.first as? OpalImagePickerRootViewController
            rootVC?.selectionImageTintColor = selectionImageTintColor
        }
    }
    
    /// Custom selection image (checkmark).
    @objc open var selectionImage: UIImage? {
        didSet {
            let rootVC = viewControllers.first as? OpalImagePickerRootViewController
            rootVC?.selectionImage = selectionImage
        }
    }
    
    /// Maximum photo selections allowed in picker (zero or fewer means unlimited).
    @objc open var maximumSelectionsAllowed: Int = -1 {
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
    @objc open var statusBarPreference = UIStatusBarStyle.default
    
    /// External `UIToolbar` barTintColor.
    @objc open var externalToolbarBarTintColor: UIColor? {
        didSet {
            let rootVC = viewControllers.first as? OpalImagePickerRootViewController
            rootVC?.toolbar.barTintColor = externalToolbarBarTintColor
        }
    }
    
    /// External `UIToolbar` and `UISegmentedControl` tint color.
    @objc open var externalToolbarTintColor: UIColor? {
        didSet {
            let rootVC = viewControllers.first as? OpalImagePickerRootViewController
            rootVC?.toolbar.tintColor = externalToolbarTintColor
            rootVC?.tabSegmentedControl.tintColor = externalToolbarTintColor
        }
    }
    
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
