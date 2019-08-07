//
//  OpalImagePickerConfiguration.swift
//  OpalImagePicker
//
//  Created by Kristos Katsanevas on 8/9/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

import Foundation

/// Configuration. Optionally change localized strings.
public class OpalImagePickerConfiguration: NSObject {
    
    var updateStrings: ((OpalImagePickerConfiguration) -> Void)?
    
    /// Localized navigation title. Defaults to "Photos".
    @objc public var navigationTitle: String? {
        didSet {
            updateStrings?(self)
        }
    }
    
    /// Localized library segment title. Only displays when using external URLs in `UISegmentedControl`.
    @objc public var librarySegmentTitle: String? {
        didSet {
            updateStrings?(self)
        }
    }
    
    /// Localized 'Cancel' button text.
    @objc public var cancelButtonTitle: String? {
        didSet {
            updateStrings?(self)
        }
    }
    
    /// Localized 'Done' button text.
    @objc public var doneButtonTitle: String? {
        didSet {
            updateStrings?(self)
        }
    }
    
    /// Localized maximum selections allowed error message displayed to the user.
    @objc public var maximumSelectionsAllowedMessage: String?
    
    /// Localized "OK" string.
    @objc public var okayString: String?
}
