//
//  ImagePickerCollectionViewCell.swift
//  OpalImagePicker
//
//  Created by Kris Katsanevas on 1/15/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

import UIKit
import Photos

class ImagePickerCollectionViewCell: UICollectionViewCell {
    
    static let scale: CGFloat = 3
    static let reuseId = String(describing: ImagePickerCollectionViewCell.self)
    
    var photoAsset: PHAsset? {
        didSet {
            loadPhotoAssetIfNeeded()
        }
    }
    
    var size: CGSize? {
        didSet {
            loadPhotoAssetIfNeeded()
        }
    }
    
    var url: URL? {
        didSet {
            loadURLIfNeeded()
        }
    }
    
    var indexPath: IndexPath? {
        didSet {
            loadURLIfNeeded()
        }
    }
    
    var cache: NSCache<NSIndexPath, NSData>?
    
    var selectionTintColor: UIColor = UIColor.black.withAlphaComponent(0.8) {
        didSet {
            overlayView?.backgroundColor = selectionTintColor
        }
    }
    
    open var selectionImageTintColor: UIColor = .white {
        didSet {
            overlayImageView?.tintColor = selectionImageTintColor
        }
    }
    
    open var selectionImage: UIImage? {
        didSet {
            overlayImageView?.image = selectionImage?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    override var isSelected: Bool {
        set {
            setSelected(newValue, animated: true)
        }
        get {
            return super.isSelected
        }
    }
    
    func setSelected(_ isSelected: Bool, animated: Bool) {
        super.isSelected = isSelected
        updateSelected(animated)
    }
    
    weak var imageView: UIImageView?
    weak var activityIndicator: UIActivityIndicatorView?
    
    weak var overlayView: UIView?
    weak var overlayImageView: UIImageView?
    
    fileprivate var imageRequestID: PHImageRequestID?
    fileprivate var urlDataTask: URLSessionTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        contentView.addSubview(activityIndicator)
        self.activityIndicator = activityIndicator
        
        let imageView = UIImageView(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        self.imageView = imageView
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: imageView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: imageView.rightAnchor),
            contentView.topAnchor.constraint(equalTo: imageView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor)
            ])
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        
        //Cancel requests if needed
        urlDataTask?.cancel()
        let manager = PHImageManager.default()
        guard let imageRequestID = self.imageRequestID else { return }
        manager.cancelImageRequest(imageRequestID)
        self.imageRequestID = nil
        
        //Remove selection
        setSelected(false, animated: false)
    }
    
    fileprivate func loadPhotoAssetIfNeeded() {
        guard let asset = photoAsset, let size = self.size else { return }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        let manager = PHImageManager.default()
        let newSize = CGSize(width: size.width * type(of: self).scale,
                             height: size.height * type(of: self).scale)
        activityIndicator?.startAnimating()
        imageRequestID = manager.requestImage(for: asset, targetSize: newSize, contentMode: .aspectFill, options: options, resultHandler: { [weak self] (result, info) in
            self?.activityIndicator?.stopAnimating()
            self?.imageRequestID = nil
            guard let result = result else {
                self?.imageView?.image = nil
                return
            }
            self?.imageView?.image = result
        })
    }
    
    fileprivate func loadURLIfNeeded() {
        guard let url = self.url,
            let indexPath = self.indexPath else {
                activityIndicator?.stopAnimating()
                imageView?.image = nil
                return
        }
        
        //Check cache first to avoid downloading image.
        if let imageData = cache?.object(forKey: indexPath as NSIndexPath) as Data?,
            let image = UIImage(data: imageData) {
            activityIndicator?.stopAnimating()
            imageView?.image = image
            return
        }
        
        activityIndicator?.startAnimating()
        urlDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard indexPath == self?.indexPath else { return }
            self?.activityIndicator?.stopAnimating()
            
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                //let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else {
                    //broken link image
                    return
            }
            
            self?.cache?.setObject(data as NSData,
                                   forKey: indexPath as NSIndexPath,
                                   cost: data.count)
            
            DispatchQueue.main.async { [weak self] in
                self?.imageView?.image = image
            }
        }
        urlDataTask?.resume()
    }
    
    fileprivate func updateSelected(_ animated: Bool) {
        if isSelected {
            addOverlay(animated)
        }
        else {
            removeOverlay(animated)
        }
    }
    
    fileprivate func addOverlay(_ animated: Bool) {
        guard self.overlayView == nil && self.overlayImageView == nil else { return }
        
        let overlayView = UIView(frame: frame)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = selectionTintColor
        contentView.addSubview(overlayView)
        self.overlayView = overlayView
        
        let overlayImageView = UIImageView(frame: frame)
        overlayImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayImageView.contentMode = .center
        overlayImageView.image = selectionImage ?? UIImage(named: "checkmark", in: Bundle.podBundle(forClass: type(of: self).self), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        overlayImageView.tintColor = selectionImageTintColor
        overlayImageView.alpha = 0
        contentView.addSubview(overlayImageView)
        self.overlayImageView = overlayImageView
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: overlayView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: overlayView.rightAnchor),
            contentView.topAnchor.constraint(equalTo: overlayView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: overlayImageView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: overlayImageView.rightAnchor),
            contentView.topAnchor.constraint(equalTo: overlayImageView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: overlayImageView.bottomAnchor)
            ])
        layoutIfNeeded()
        
        let duration = animated ? 0.2 : 0.0
        UIView.animate(withDuration: duration, animations: {
            overlayView.alpha = 0.7
            overlayImageView.alpha = 1
        })
    }
    
    fileprivate func removeOverlay(_ animated: Bool) {
        guard let overlayView = self.overlayView,
            let overlayImageView = self.overlayImageView else {
                self.overlayView?.removeFromSuperview()
                self.overlayImageView?.removeFromSuperview()
                return
        }
        
        let duration = animated ? 0.2 : 0.0
        UIView.animate(withDuration: duration, animations: {
            overlayView.alpha = 0
            overlayImageView.alpha = 0
        }, completion: { (_) in
            overlayView.removeFromSuperview()
            overlayImageView.removeFromSuperview()
        })
    }
}
