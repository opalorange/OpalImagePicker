//
//  ViewController.swift
//  OpalImagePickerDemo
//
//  Created by Kris Katsanevas on 1/15/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

import UIKit
import OpalImagePicker
import Photos

class ViewController: UIViewController {

    @IBAction func photoLibraryTapped(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            //Show error to user?
            return
        }

        //Example Instantiating OpalImagePickerController with Closures
        let imagePicker = OpalImagePickerController()

        //Present Image Picker
        presentOpalImagePickerController(imagePicker, animated: true, select: { (_) in
            //Save Images, update UI

            //Dismiss Controller
            imagePicker.dismiss(animated: true, completion: nil)
        }, cancel: {
            //Cancel action?

        })
    }
}
