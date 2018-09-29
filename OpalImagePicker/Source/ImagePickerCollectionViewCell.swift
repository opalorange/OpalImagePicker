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
    
    var timeText: String? {
        didSet {
            let isTimeHidden = timeText == nil
            timeLabel.text = timeText
            timeOverlay.isHidden = isTimeHidden
            timeLabel.isHidden = isTimeHidden
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
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    lazy var timeOverlay: UIImageView = {
        let timeOverlay = UIImageView()
        timeOverlay.translatesAutoresizingMaskIntoConstraints = false
        let timeOverlayImage = UIImage(named: "gradient",
                                       in: Bundle.podBundle(forClass: type(of: self).self),
                                       compatibleWith: nil)
        timeOverlay.image = timeOverlayImage?.resizableImage(withCapInsets: .zero,
                                                             resizingMode: .stretch)
        timeOverlay.isHidden = true
        return timeOverlay
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.boldSystemFont(ofSize: 10)
        timeLabel.textColor = .white
        timeLabel.isHidden = true
        return timeLabel
    }()
    
    weak var overlayView: UIView?
    weak var overlayImageView: UIImageView?
    private var imageRequestID: PHImageRequestID?
    private var urlDataTask: URLSessionTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        
        contentView.addSubview(activityIndicator)
        contentView.addSubview(imageView)
        contentView.addSubview(timeOverlay)
        contentView.addSubview(timeLabel)
        
        let heightConstraint = NSLayoutConstraint(item: timeOverlay,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 25)
        
        NSLayoutConstraint.activate([
            timeLabel.constraintEqualTo(with: contentView, attribute: .right, constant: -5),
            timeLabel.constraintEqualTo(with: contentView, attribute: .bottom, constant: -5),
            timeOverlay.constraintEqualTo(with: contentView, attribute: .left),
            timeOverlay.constraintEqualTo(with: contentView, attribute: .right),
            timeOverlay.constraintEqualTo(with: contentView, attribute: .bottom),
            heightConstraint
            ])
        
        let constraintsToFill = contentView.constraintsToFill(otherView: imageView)
        let constraintsToCenter = contentView.constraintsToCenter(otherView: activityIndicator)
        NSLayoutConstraint.activate(constraintsToFill + constraintsToCenter)
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        
        timeLabel.isHidden = true
        timeOverlay.isHidden = true
        
        //Cancel requests if needed
        urlDataTask?.cancel()
        let manager = PHImageManager.default()
        guard let imageRequestID = self.imageRequestID else { return }
        manager.cancelImageRequest(imageRequestID)
        self.imageRequestID = nil
        
        //Remove selection
        setSelected(false, animated: false)
    }
    
    private func loadPhotoAssetIfNeeded() {
        guard let indexPath = self.indexPath,
            let asset = photoAsset, let size = self.size else { return }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .fast
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        timeText = asset.duration > 0 ? asset.duration.string() : nil
        
        let manager = PHImageManager.default()
        let newSize = CGSize(width: size.width * type(of: self).scale,
                             height: size.height * type(of: self).scale)
        activityIndicator.startAnimating()
        imageRequestID = manager.requestImage(for: asset, targetSize: newSize, contentMode: .aspectFill, options: options, resultHandler: { [weak self] (result, _) in
            guard self?.indexPath?.item == indexPath.item else { return }
            self?.activityIndicator.stopAnimating()
            self?.imageRequestID = nil
            self?.imageView.image = result
        })
    }
    
    private func loadURLIfNeeded() {
        guard let url = self.url,
            let indexPath = self.indexPath else {
                activityIndicator.stopAnimating()
                imageView.image = nil
                return
        }
        
        //Check cache first to avoid downloading image.
        if let imageData = cache?.object(forKey: indexPath as NSIndexPath) as Data?,
            let image = UIImage(data: imageData) {
            activityIndicator.stopAnimating()
            imageView.image = image
            return
        }
        
        activityIndicator.startAnimating()
        urlDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard indexPath == self?.indexPath else { return }
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                
                guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data) else {
                        //broken link image
                        self?.imageView.image = UIImage()
                        return
                }
                
                self?.cache?.setObject(data as NSData,
                                       forKey: indexPath as NSIndexPath,
                                       cost: data.count)
                
                self?.imageView.image = image
            }
        }
        urlDataTask?.resume()
    }
    
    private func updateSelected(_ animated: Bool) {
        if isSelected {
            addOverlay(animated)
        } else {
            removeOverlay(animated)
        }
    }
    
    private func addOverlay(_ animated: Bool) {
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
        
        let overlayViewConstraints = overlayView.constraintsToFill(otherView: contentView)
        let overlayImageViewConstraints = overlayImageView.constraintsToFill(otherView: contentView)
        NSLayoutConstraint.activate(overlayImageViewConstraints + overlayViewConstraints)
        layoutIfNeeded()
        
        let duration = animated ? 0.2 : 0.0
        UIView.animate(withDuration: duration, animations: {
            overlayView.alpha = 0.7
            overlayImageView.alpha = 1
        })
    }
    
    private func removeOverlay(_ animated: Bool) {
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
