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
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        isDidFinishPickingAssetsCalled = true
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        
    }
}
