//
//  MainViewController.swift
//  OpalImagePickerDemo
//
//  Created by Mihail Șalari on 2/9/17.
//  Copyright © 2017 SIC. All rights reserved.
//

import UIKit
import Photos
import OpalImagePicker

class MainViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var images = [UIImage]()
    
    
    // MARK: - LyfeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier, for: indexPath) as! MainCollectionViewCell
        let image = images[indexPath.row]
        cell.imageView.image = image
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        self.performSegue(withIdentifier: "ShowImageSegue", sender: image)
    }
}


extension MainViewController {
    
    @IBAction func photoLibraryTapped() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            //Show error to user?
            return
        }
        
        //Example Instantiating OpalImagePickerController with Closures
        let imagePicker = OpalImagePickerController()
        
        //Present Image Picker
        presentOpalImagePickerController(imagePicker, animated: true, select: { [unowned self] (assets) in
            //TODO: Save Images, update UI
            
            let importedImages = self.getImagesFrom(assets)
            self.images += importedImages
            self.collectionView.reloadData()
            
            
            //Dismiss Controller
            imagePicker.dismiss(animated: true, completion: nil)
        }, cancel: {
            //TODO: Cancel action?
            
        })
    }
}


// MARK: - Navigation

extension MainViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowImageSegue":
                if let previewController = segue.destination as? PreviewViewController, let image = sender as? UIImage {
                    previewController.previewImage = image
                }
                
            default:
                break
            }
        }
    }
}


// MARK: - Get images

extension MainViewController {
    
    func getImagesFrom(_ assets: [PHAsset]) -> [UIImage] {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        var images = [UIImage]()
        
        for asset in assets {
            manager.requestImage(for: asset,
                                 targetSize: CGSize(width: view.frame.width,
                                                    height: view.frame.height),
                                 contentMode: .aspectFit,
                                 options: option,
                                 resultHandler: { (result, info) -> Void in
                                    
                                    if let result = result {
                                        images.append(result)
                                    }
            })
        }
        
        return images
    }
}
