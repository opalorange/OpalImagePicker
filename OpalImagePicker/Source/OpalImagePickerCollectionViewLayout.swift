//
//  OpalImagePickerCollectionViewLayout.swift
//  OpalImagePicker
//
//  Created by Kris Katsanevas on 1/15/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

import UIKit

open class OpalImagePickerCollectionViewLayout: UICollectionViewLayout {
    
    open var estimatedImageSize: CGFloat {
        guard let collectionView = self.collectionView else { return 80 }
        return collectionView.traitCollection.horizontalSizeClass == .regular ? 160 : 80
    }
    
    var sizeOfItem: CGFloat = 0
    fileprivate var cellLayoutInfo: [IndexPath:UICollectionViewLayoutAttributes] = [:]
    
    open override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        updateItemSizes()
    }
    
    open override func prepare() {
        updateItemSizes()
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellLayoutInfo[indexPath]
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil }
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        return cellLayoutInfo.filter { (indexPath, layoutAttribute) -> Bool in
            return layoutAttribute.frame.intersects(rect) && indexPath.item < numberOfItems
            }.map { $0.value }
    }
    
    open override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return CGSize.zero }
        let numberOfItemsAcross = Int(collectionView.bounds.width/estimatedImageSize)
        
        guard numberOfItemsAcross > 0 else { return CGSize.zero }
        let widthOfItem = collectionView.bounds.width/CGFloat(numberOfItemsAcross)
        sizeOfItem = widthOfItem
        
        var totalNumberOfItems = 0
        for section in 0..<collectionView.numberOfSections {
            totalNumberOfItems += collectionView.numberOfItems(inSection: section)
        }
        
        let numberOfRows = Int(ceilf(Float(totalNumberOfItems)/Float(numberOfItemsAcross)))
        var size = collectionView.frame.size
        size.height = CGFloat(numberOfRows) * widthOfItem
        return size
    }
    
    fileprivate func updateItemSizes() {
        guard let collectionView = self.collectionView else { return }
        let numberOfItemsAcross = Int(collectionView.bounds.width/estimatedImageSize)
        
        guard numberOfItemsAcross > 0 else { return }
        let widthOfItem = collectionView.bounds.width/CGFloat(numberOfItemsAcross)
        sizeOfItem = widthOfItem
        
        cellLayoutInfo = [:]
        
        var yPosition: CGFloat = 0
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let column = item % numberOfItemsAcross
                
                let xPosition = CGFloat(column) * widthOfItem
                layoutAttributes.frame = CGRect(x: xPosition, y: yPosition, width: widthOfItem, height: widthOfItem)
                cellLayoutInfo[indexPath] = layoutAttributes
                
                //When at the end of row increment y position.
                if column == numberOfItemsAcross-1 {
                    yPosition += widthOfItem
                }
            }
        }
    }
}
