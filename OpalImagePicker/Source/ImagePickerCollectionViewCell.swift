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
    
    static let reuseId = String(describing: ImagePickerCollectionViewCell.self)
    
    var photoAsset: PHAsset? {
        didSet {
            loadIfNeeded()
        }
    }
    
    var size: CGSize? {
        didSet {
            loadIfNeeded()
        }
    }
    
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
        
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activate([
                contentView.leftAnchor.constraint(equalTo: imageView.leftAnchor),
                contentView.rightAnchor.constraint(equalTo: imageView.rightAnchor),
                contentView.topAnchor.constraint(equalTo: imageView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
                contentView.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor),
                contentView.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor)
                ])
        } else {
            // Fallback on earlier versions
            
            contentView.addConstraintsWithFormat("H:|[v0]|", views: imageView)
            contentView.addConstraintsWithFormat("V:|[v0]|", views: imageView)
            
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            let views = ["contentView": contentView, "activityIndicator": activityIndicator]
            let visualFormat = ":[contentView]-(<=1)-[activityIndicator(30)]"
            
            /// Center horisontally
            let horizontalConstraint = NSLayoutConstraint.constraints(
                withVisualFormat: "V" + visualFormat,
                options: .alignAllCenterX,
                metrics: nil,
                views: views)
            
            contentView.addConstraints(horizontalConstraint)
            
            /// Center vertically
            let verticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H" + visualFormat,
                options: .alignAllCenterY,
                metrics: nil,
                views: views)
            
            contentView.addConstraints(verticalConstraints)
        }
        
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        
        //Cancel request if needed
        let manager = PHImageManager.default()
        guard let imageRequestID = self.imageRequestID else { return }
        manager.cancelImageRequest(imageRequestID)
        self.imageRequestID = nil
        
        //Remove selection
        setSelected(false, animated: false)
    }
    
    fileprivate func loadIfNeeded() {
        guard let asset = photoAsset, let size = self.size else { return }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        let manager = PHImageManager.default()
        imageRequestID = manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options, resultHandler: { [weak self] (result, info) in
            self?.imageRequestID = nil
            guard let result = result else {
                self?.imageView?.image = nil
                return
            }
            self?.imageView?.image = result
        })
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
        
        if #available(iOS 9.0, *) {
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
        } else {
            // Fallback on earlier versions
            
            contentView.addConstraintsWithFormat("H:|[v0]|", views: overlayView)
            contentView.addConstraintsWithFormat("V:|[v0]|", views: overlayView)
            
            contentView.addConstraintsWithFormat("H:|[v0]|", views: overlayImageView)
            contentView.addConstraintsWithFormat("V:|[v0]|", views: overlayImageView)
        }
        
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
