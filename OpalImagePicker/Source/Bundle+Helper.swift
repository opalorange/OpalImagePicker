//
//  Bundle+Helper.swift
//  OpalImagePicker
//
//  Created by Kris Katsanevas on 1/15/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

import Foundation

extension Bundle {
    static func podBundle(forClass: AnyClass) -> Bundle? {
        
        let bundleForClass = Bundle(for: forClass)
        
        if let bundleURL = bundleForClass.url(forResource: "OpalImagePickerResources", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                return bundle
            } else {
                assertionFailure("Could not load the bundle")
            }
        } else {
            assertionFailure("Could not create a path to the bundle")
        }
        return nil
    }
}
