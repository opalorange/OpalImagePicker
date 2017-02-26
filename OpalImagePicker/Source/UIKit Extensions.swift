//
//  UIKit Extensions.swift
//  OpalImagePicker
//
//  Created by Mihail Șalari on 2/9/17.
//  Copyright © 2017 SIC. All rights reserved.
//

import UIKit

// MARK: - UIView

public extension UIView {
    
    public func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


// MARK: - Bundle

public extension Bundle {
    
    static func podMainBundle(forClass: AnyClass) -> Bundle {
        return Bundle.main
    }
    
    static func podBundle(forClass: AnyClass) -> Bundle? {
        
        let bundleForClass = Bundle(for: forClass)
        
        if let bundleURL = bundleForClass.url(forResource: "OpalImagePickerResources", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                return bundle
            }
            else {
                assertionFailure("Could not load the bundle")
            }
        }
        else {
            assertionFailure("Could not create a path to the bundle")
        }
        return nil
    }

}
