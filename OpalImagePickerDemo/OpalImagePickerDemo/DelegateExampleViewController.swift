//
//  DelegateExampleViewController.swift
//  OpalImagePickerDemo
//
//  Created by Kristos Katsanevas on 9/24/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

import UIKit
import OpalImagePicker

class DelegateExampleViewController: UIViewController {
    @IBAction func photoLibraryTapped(_ sender: UIButton) {
        //Example instantiating OpalImagePickerController with delegate
        let imagePicker = OpalImagePickerController()
        imagePicker.imagePickerDelegate = self
        imagePicker.maximumSelectionsAllowed = 10
        present(imagePicker, animated: true, completion: nil)
    }
}

extension DelegateExampleViewController: OpalImagePickerControllerDelegate {
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        //Save Images, update UI
        
        //Dismiss Controller
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerNumberOfExternalItems(_ picker: OpalImagePickerController) -> Int {
        return 1
    }
    
    func imagePickerTitleForExternalItems(_ picker: OpalImagePickerController) -> String {
        return NSLocalizedString("External", comment: "External (title for UISegmentedControl)")
    }
    
    func imagePicker(_ picker: OpalImagePickerController, imageURLforExternalItemAtIndex index: Int) -> URL? {
        return URL(string: "https://placeimg.com/500/500/nature")
    }
}
