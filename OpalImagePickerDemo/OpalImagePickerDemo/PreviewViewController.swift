//
//  PreviewViewController.swift
//  OpalImagePickerDemo
//
//  Created by Mihail Șalari on 2/9/17.
//  Copyright © 2017 SIC. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    
    var previewImage: UIImage!
    
    
    
    // MARK: - LyfeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.image = previewImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
