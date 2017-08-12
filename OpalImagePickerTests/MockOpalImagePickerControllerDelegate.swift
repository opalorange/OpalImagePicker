//
//  MockDelegate.swift
//  OpalImagePicker
//
//  Created by Kristos Katsanevas on 1/16/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

import UIKit
import Photos
import OpalImagePicker

class MockOpalImagePickerControllerDelegate: OpalImagePickerControllerDelegate {
    
    var isDidFinishPickingAssetsCalled = false
    var isDidFinishPickingExternalCalled = false
    var isCancelledCalled = false
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        isDidFinishPickingAssetsCalled = true
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        isCancelledCalled = true
    }
    
    func imagePickerNumberOfExternalItems(_ picker: OpalImagePickerController) -> Int {
        return 1
    }
    
    func imagePickerTitleForExternalItems(_ picker: OpalImagePickerController) -> String {
        return "External"
    }
    
    func imagePicker(_ picker: OpalImagePickerController, imageURLforExternalItemAtIndex index: Int) -> URL? {
        return nil
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingExternalURLs urls: [URL]) {
        isDidFinishPickingExternalCalled = true
    }
}
