//
//  OpalImagePickerManager.swift
//  OpalImagePicker
//
//  Created by Mihail Șalari on 2/9/17.
//  Copyright © 2017 SIC. All rights reserved.
//

import Photos

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
