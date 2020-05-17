//
//  ViewController.swift
//  OpalImagePicker
//
//  Created by Kristos Katsanevas on 1/15/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func launchPicker(_ sender: Any) {
        let imagePicker = OpalImagePickerController()
        presentOpalImagePickerController(imagePicker, animated: true,
            select: { (assets) in
                //Select Assets
                 self.dismiss(animated: true, completion: nil)
            }, cancel: {
                //Cancel
            })
    }
}
