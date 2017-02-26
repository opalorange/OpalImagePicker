//
//  OpalImagePickerRootViewController.swift
//  OpalImagePicker
//
//  Created by Kristos Katsanevas on 1/16/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

import UIKit
import Photos

/// Image Picker Root View Controller contains the logic for selecting images. The images are displayed in a `UICollectionView`, and multiple images can be selected.
open class OpalImagePickerRootViewController: UIViewController {
    
    /// Delegate for Image Picker. Notifies when images are selected (done is tapped) or when the Image Picker is cancelled.
    open weak var delegate: OpalImagePickerControllerDelegate?
    
    /// `UICollectionView` for displaying images
    open weak var collectionView: UICollectionView?
    
    /// Custom Tint Color for overlay of selected images.
    open var selectionTintColor: UIColor? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    /// Custom Tint Color for selection image (checkmark).
    open var selectionImageTintColor: UIColor? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    /// Custom selection image (checkmark).
    open var selectionImage: UIImage? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    /// Page size for paging through the Photo Assets in the Photo Library. Defaults to 100. Must override to change this value.
    open let pageSize = 100
    
    var photoAssets: PHFetchResult<PHAsset> = PHFetchResult()
    weak var doneButton: UIBarButtonItem?
    weak var cancelButton: UIBarButtonItem?
    
    internal var collectionViewLayout: OpalImagePickerCollectionViewLayout? {
        return collectionView?.collectionViewLayout as? OpalImagePickerCollectionViewLayout
    }
    
    internal lazy var fetchOptions: PHFetchOptions = {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return fetchOptions
    }()
    
    internal var fetchLimit: Int {
        get {
            if #available(iOS 9.0, *) {
                return fetchOptions.fetchLimit
            } else {
                // Fallback on earlier versions
                
                return 5 // TODO: - Need to change
            }
        }
        set {
            if #available(iOS 9.0, *) {
                fetchOptions.fetchLimit = newValue
            } else {
                // Fallback on earlier versions
                // TODO: - need to change
            }
        }
    }

    
    fileprivate var photosCompleted = 0
    fileprivate var savedImages: [UIImage] = []
    
    /// Initializer
    public required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Initializer (Do not use this View Controller in Interface Builder)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Cannot init \(String(describing: OpalImagePickerRootViewController.self)) from Interface Builder")
    }
    
    fileprivate func setup() {
        requestPhotoAccessIfNeeded(PHPhotoLibrary.authorizationStatus())
        if #available(iOS 9.0, *) {
            fetchOptions.fetchLimit = pageSize
        } else {
            // Fallback on earlier versions
            
            // TODO: - need to change
        }
        photoAssets = PHAsset.fetchAssets(with: fetchOptions)
        
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: OpalImagePickerCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: ImagePickerCollectionViewCell.reuseId)
        view.addSubview(collectionView)
        self.collectionView = collectionView
        
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activate([
                view.leftAnchor.constraint(equalTo: collectionView.leftAnchor),
                view.rightAnchor.constraint(equalTo: collectionView.rightAnchor),
                view.topAnchor.constraint(equalTo: collectionView.topAnchor),
                view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
                ])
        } else {
            // Fallback on earlier versions
            
            view.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
            view.addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        }
        
        view.layoutIfNeeded()
    }
    
    
    /// Load View
    open override func loadView() {
        view = UIView()
    }
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        navigationItem.title = NSLocalizedString("Photos", comment: "")
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem = cancelButton
        self.cancelButton = cancelButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        doneButton.isEnabled = false
        navigationItem.rightBarButtonItem = doneButton
        self.doneButton = doneButton
    }
    
    func cancelTapped() {
        dismiss(animated: true) { [weak self] in
            guard let imagePicker = self?.navigationController as? OpalImagePickerController else { return }
            self?.delegate?.imagePickerDidCancel?(imagePicker)
        }
    }
    
    func doneTapped() {
        guard let imagePicker = navigationController as? OpalImagePickerController,
            let collectionViewLayout = collectionView?.collectionViewLayout as? OpalImagePickerCollectionViewLayout else { return }
        let indexPathsForSelectedItems = collectionView?.indexPathsForSelectedItems ?? []
        
        var photoAssets: [PHAsset] = []
        for indexPath in indexPathsForSelectedItems {
            guard indexPath.item < self.photoAssets.count else { continue }
            photoAssets += [self.photoAssets.object(at: indexPath.item)]
        }
        
        
        delegate?.imagePicker?(imagePicker, didFinishPickingAssets: photoAssets)
        
        //Skip next step for optimization if `imagePicker:didFinishPickingAssets:` isn't implemented on delegate
        if let nsDelegate = delegate as? NSObject,
            !nsDelegate.responds(to: #selector(OpalImagePickerControllerDelegate.imagePicker(_:didFinishPickingImages:))) {
            return
        }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        photosCompleted = 0
        for photoAsset in photoAssets {
            let size = CGSize(width: collectionViewLayout.sizeOfItem * 3, height: collectionViewLayout.sizeOfItem * 3)
            PHImageManager.default().requestImage(for: photoAsset, targetSize: size, contentMode: .aspectFill, options: options, resultHandler: { [weak self] (result, info) in
                guard let strongSelf = self else { return }
                if let image = result {
                    strongSelf.savedImages += [image]
                }
                
                strongSelf.photosCompleted += 1
                if strongSelf.photosCompleted == photoAssets.count {
                    strongSelf.delegate?.imagePicker?(imagePicker, didFinishPickingImages: strongSelf.savedImages)
                    strongSelf.savedImages = []
                }
            })
        }
    }
    
    fileprivate func updateDoneButton() {
        guard let indexPathsForSelectedItems = collectionView?.indexPathsForSelectedItems else {
            doneButton?.isEnabled = false
            return
        }
        doneButton?.isEnabled = indexPathsForSelectedItems.count > 0
    }
    
    fileprivate func fetchNextPageIfNeeded(indexPath: IndexPath) {
        guard indexPath.item == fetchLimit-1 else { return }
        
        let oldFetchLimit = fetchLimit
        fetchLimit += pageSize
        photoAssets = PHAsset.fetchAssets(with: fetchOptions)
        
        var indexPaths: [IndexPath] = []
        for i in oldFetchLimit..<photoAssets.count {
            indexPaths += [IndexPath(item: i, section: 0)]
        }
        collectionView?.insertItems(at: indexPaths)
    }
    
    fileprivate func requestPhotoAccessIfNeeded(_ status: PHAuthorizationStatus) {
        guard status == .notDetermined else { return }
        PHPhotoLibrary.requestAuthorization { [weak self] (authorizationStatus) in
            DispatchQueue.main.async { [weak self] in
                self?.photoAssets = PHAsset.fetchAssets(with: self?.fetchOptions)
                self?.collectionView?.reloadData()
            }
        }
    }
}

//MARK: - Collection View Delegate

extension OpalImagePickerRootViewController: UICollectionViewDelegate {
    
    
    /// Collection View did select item at `IndexPath`
    ///
    /// - Parameters:
    ///   - collectionView: the `UICollectionView`
    ///   - indexPath: the `IndexPath`
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateDoneButton()
    }
    
    
    /// Collection View did de-select item at `IndexPath`
    ///
    /// - Parameters:
    ///   - collectionView: the `UICollectionView`
    ///   - indexPath: the `IndexPath`
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateDoneButton()
    }
}

//MARK: - Collection View Data Source

extension OpalImagePickerRootViewController: UICollectionViewDataSource {
    
    
    /// Returns Collection View Cell for item at `IndexPath1
    ///
    /// - Parameters:
    ///   - collectionView: the `UICollectionView`
    ///   - indexPath: the `IndexPath`
    /// - Returns: Returns the `UICollectionViewCell`
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fetchNextPageIfNeeded(indexPath: indexPath)
        
        guard let layoutAttributes = collectionViewLayout?.layoutAttributesForItem(at: indexPath),
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCollectionViewCell.reuseId, for: indexPath) as? ImagePickerCollectionViewCell else { return UICollectionViewCell() }
        let photoAsset = photoAssets.object(at: indexPath.item)
        cell.photoAsset = photoAsset
        cell.size = layoutAttributes.frame.size
        
        if let selectionTintColor = self.selectionTintColor {
            cell.selectionTintColor = selectionTintColor
        }
        if let selectionImageTintColor = self.selectionImageTintColor {
            cell.selectionImageTintColor = selectionImageTintColor
        }
        if let selectionImage = self.selectionImage {
            cell.selectionImage = selectionImage
        }
        
        return cell
    }
    
    
    /// Returns the number of items in a given section
    ///
    /// - Parameters:
    ///   - collectionView: the `UICollectionView`
    ///   - section: the given section of the `UICollectionView`
    /// - Returns: Returns an `Int` for the number of rows.
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
}
